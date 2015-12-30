/*
 * This file is part of libzbc.
 * 
 * Copyright (C) 2009-2014, HGST, Inc.  This software is distributed
 * under the terms of the GNU Lesser General Public License version 3,
 * or any later version, "as is," without technical support, and WITHOUT
 * ANY WARRANTY, without even the implied warranty of MERCHANTABILITY
 * or FITNESS FOR A PARTICULAR PURPOSE.  You should have received a copy
 * of the GNU Lesser General Public License along with libzbc.  If not,
 * see <http://www.gnu.org/licenses/>.
 * 
 * Authors: Damien Le Moal (damien.lemoal@hgst.com)
 *          Christophe Louargant (christophe.louargant@hgst.com)
 */

/***** Including files *****/

#define _GNU_SOURCE     /* O_LARGEFILE */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <errno.h>
#include <signal.h>
#include <fcntl.h>
#include <time.h>
#include <sys/time.h>
#include <sys/stat.h>
#include <sys/ioctl.h>
#include <linux/fs.h>

#include <libzbc/zbc.h>

/***** Local functions *****/

/**
 * I/O abort.
 */
static int zbc_read_zone_abort = 0;

/**
 * System time in usecs.
 */
static __inline__ unsigned long long
zbc_read_zone_usec(void)
{
	struct timeval tv;

	gettimeofday(&tv, NULL);

	return( (unsigned long long) tv.tv_sec * 1000000LL + (unsigned long long) tv.tv_usec );

}

/**
 * Signal handler.
 */
static void
zbc_read_zone_sigcatcher(int sig)
{

	zbc_read_zone_abort = 1;

	return;

}

/**
 * for script file 
 * Fenggang wu
 */
#define MAX_LEN 90
#define MAX_LINE_NO 1048576


/**
 * job_struct struct, representing all the task in the script
 */
struct job_struct {
	int num;
	struct task_struct* tasks;
};

/**
 * task_struct struct, representing a single line in the script
 */
struct task_struct {
	int zidx; /* zone index */
	long long lba_ofst;
	uint32_t lba_count; 
	int rep; /* time to repeat */
};

/**
 * parse the  script file and store the result into the job_struct
 * @ job: a pointer to a job struct
 * @ script_file: the script file.
 * Fenggang Wu
 */
int 
parse_script(
	struct job_struct* job,
	char* script_file)
{
	FILE *fp;
	char line[MAX_LEN];
	int i = 0;

	job->tasks = malloc(sizeof(struct task_struct) * MAX_LINE_NO);

	if ((fp = fopen(script_file, "r")) == NULL) {
		fprintf(stderr,"unable to open script_file:%s\n", script_file);
		return -1;
	}

	while(fgets(line, MAX_LEN, fp) != NULL)
	{
		if (line[0] == '#')
			continue;
		if (4 != sscanf(line, "%d %Ld %u %d", 
				&job->tasks[i].zidx,
				&job->tasks[i].lba_ofst,
				&job->tasks[i].lba_count,
				&job->tasks[i].rep))
			continue;

		printf("%d %Ld %u %d\n",
		       job->tasks[i].zidx,
		       job->tasks[i].lba_ofst,
		       job->tasks[i].lba_count,
		       job->tasks[i].rep);
		++i;
	}

	job->num = i;
	printf("script file %s has %d lines\n", script_file, job->num);

	fclose(fp);

	return 0;
}

/***** Main *****/

int main(int argc,
         char **argv)
{
	struct zbc_device_info info;
	struct zbc_device *dev = NULL;
	unsigned long long elapsed;
	unsigned long long bcount = 0;
	unsigned long long brate;
	int zidx;
	int fd = -1, i, j, k, ret = 1;
	void *iobuf = NULL;
	uint32_t lba_count;
	unsigned long long iocount = 0;
	struct zbc_zone *zones = NULL;
	struct zbc_zone *iozone = NULL;
	unsigned int nr_zones;
	char *path, *file = NULL;
	long long lba_ofst = 0;
	long long rp = -1; /*  read pointer. hack for sequential read */
	char *script_file = NULL;
	int num_run = 1;
	struct job_struct job;
	size_t ioalign;

	/* Check command line */
	if ( argc < 3 ) {
	usage:
		printf("Usage: %s [options] <dev>\n"
		       "  Read a zone up to the current write pointer\n"
		       "  or the number of I/O specified is executed\n"
		       "Options:\n"
		       "    -v         : Verbose mode\n"
		       "    -p <script> : the <script> to be processed\n"
		       "    -k <num_run>: repeat the script for <num_run> times\n",
		       argv[0]);
		return( 1 );
	}

	/* Parse options */
	for(i = 1; i < (argc - 1); i++) {
		if ( strcmp(argv[i], "-v") == 0 ) {
			zbc_set_log_level("debug");
		} else if ( strcmp(argv[i], "-p") == 0 ) {
			if ( i >= (argc - 1) )
				goto usage;
			i++;
			script_file = argv[i];
		} else if ( strcmp(argv[i], "-k") == 0 ) {
			if ( i >= (argc - 1) )
				goto usage;
			i++;
			num_run = atoi(argv[i]);
			if ( num_run <= 0 ) {
				fprintf(stderr, "Invalid number total runs\n");
				goto out_failure;
			}
		} else if ( argv[i][0] == '-' ) {
			fprintf(stderr,
				"Unknown option \"%s\"\n",
				argv[i]);
			goto usage;
		} else {
			break;
		}
	}

	if ( i != (argc - 1) ) {
		goto usage;
	}

	printf("parsing script file: %s\n", script_file);
	if (parse_script(&job, script_file) < 0){
		fprintf(stderr,"error parsing script file %s\n", script_file);
		goto out_failure;
	}

	printf("total num_run=%d\n", num_run);

	/* Get parameters */
	path = argv[i];

	/* Setup signal handler */
	signal(SIGQUIT, zbc_read_zone_sigcatcher);
	signal(SIGINT, zbc_read_zone_sigcatcher);
	signal(SIGTERM, zbc_read_zone_sigcatcher);

	/* Open device */
	ret = zbc_open(path, O_RDONLY, &dev);
	if ( ret != 0 ) {
		return( 1 );
	}

	ret = zbc_get_device_info(dev, &info);
	if ( ret < 0 ) {
		fprintf(stderr,
			"zbc_get_device_info failed\n");
		goto out;
	}

	/* Get zone list */
	ret = zbc_list_zones(dev, 0, ZBC_RO_ALL, &zones, &nr_zones);
	if ( ret != 0 ) {
		fprintf(stderr, "zbc_list_zones failed\n");
		ret = 1;
		goto out;
	}

	printf("Device %s: %s\n",
	       path,
	       info.zbd_vendor_id);
	printf("    %s interface, %s disk model\n",
	       zbc_disk_type_str(info.zbd_type),
	       zbc_disk_model_str(info.zbd_model));
	printf("    %llu logical blocks of %u B\n",
	       (unsigned long long) info.zbd_logical_blocks,
	       (unsigned int) info.zbd_logical_block_size);
	printf("    %llu physical blocks of %u B\n",
	       (unsigned long long) info.zbd_physical_blocks,
	       (unsigned int) info.zbd_physical_block_size);
	printf("    %.03F GB capacity\n",
	       (double) (info.zbd_physical_blocks * info.zbd_physical_block_size) / 1000000000);


	srand(time(NULL));
	for (j = 0; j < num_run; j++) {
		printf("------processing script (%d/%d)------\n", j + 1, num_run);
		rp = -1;
		for (i = 0; i < job.num; i++) {
			zidx = job.tasks[i].zidx;

			if (zidx < 0 ) {
				fprintf(stderr,"skip invalid zone number %d\n",
					job.tasks[i].zidx);
				continue;
			}

			/* Get target zone */
			if ( zidx >= (int)nr_zones ) {
				fprintf(stderr,"skip zone %d: not found\n", 
					zidx);
				continue;
			}
			iozone = &zones[zidx];

			printf("Target zone: Zone %d / %d, type 0x%x (%s), cond 0x%x (%s), need_reset %d, non_seq %d, LBA %llu, %llu sectors, wp %llu\n",
			       zidx,
			       nr_zones,
			       zbc_zone_type(iozone),
			       zbc_zone_type_str(zbc_zone_type(iozone)),
			       zbc_zone_condition(iozone),
			       zbc_zone_condition_str(zbc_zone_condition(iozone)),
			       zbc_zone_need_reset(iozone),
			       zbc_zone_non_seq(iozone),
			       zbc_zone_start_lba(iozone),
			       zbc_zone_length(iozone),
			       zbc_zone_wp_lba(iozone));

			/* Check the IO size */
			if (job.tasks[i].lba_count > ZBC_MAX_LBA_CNT){
				fprintf(stderr,"skip: io size connot be larger than 512K"
					" (lba_count <= 1024)");
				continue;
			} 


			/* Check I/O size alignment */
			if ( zbc_zone_sequential(iozone)){
				ioalign = info.zbd_physical_block_size;
				/* Get an I/O buffer */
				if(posix_memalign((void **) &iobuf, ioalign, 
						  job.tasks[i].lba_count * 
						  info.zbd_physical_block_size)){
					fprintf(stderr,"skip: no memory for I/O buffer"
						" (%u B)\n",
						job.tasks[i].lba_count * 
						info.zbd_physical_block_size);
					continue;
				}
			} else {
				ioalign = info.zbd_logical_block_size;
				/* Get an I/O buffer */
				if(posix_memalign((void **) &iobuf, ioalign, 
						  job.tasks[i].lba_count * 
						  info.zbd_logical_block_size)){
					fprintf(stderr,"skip: no memory for I/O buffer"
						" (%u B)\n",
						job.tasks[i].lba_count * 
						info.zbd_logical_block_size);
					continue;
				}
			}

			if (job.tasks[i].lba_ofst < 0 && rp < 0) {
//				fprintf(stderr, "skip negative lba_ofst %lld\n",
//					job.tasks[i].lba_ofst);
//				continue;
				rp = 0;
			}

			for (k = 0; k < job.tasks[i].rep; k++){
				
				lba_ofst = job.tasks[i].lba_ofst < 0?
					rp: job.tasks[i].lba_ofst;
				lba_count = job.tasks[i].lba_count;
				rp += lba_count;

				/* Do not exceed the end of the zone */
				if ((lba_ofst + lba_count) > 
				    (long long)zbc_zone_length(iozone) ) {
					lba_count = zbc_zone_length(iozone) - lba_ofst;
				}

				if (!lba_count) {
					continue;
				}

				printf("Reading %u blks from zone %d from"
				       " lba_offset=%Ld (%d/%d)\n",
				       lba_count,
				       zidx,
				       lba_ofst,
				       k + 1, job.tasks[i].rep);

				printf("zone type 0x%x (%s), cond 0x%x (%s), need_reset %d, non_seq %d, LBA %llu, %llu sectors, wp %llu\n\n",
				       zbc_zone_type(iozone),
				       zbc_zone_type_str(zbc_zone_type(iozone)),
				       zbc_zone_condition(iozone),
				       zbc_zone_condition_str(zbc_zone_condition(iozone)),
				       zbc_zone_need_reset(iozone),
				       zbc_zone_non_seq(iozone),
				       zbc_zone_start_lba(iozone),
				       zbc_zone_length(iozone),
				       zbc_zone_wp_lba(iozone));

				elapsed = zbc_read_zone_usec();
			    
				if (! zbc_read_zone_abort) {
					/* Read zone */
				    
					ret = zbc_pread(dev, iozone, iobuf, lba_count, lba_ofst);
				
					if (ret <= 0){
						fprintf(stderr, 
							"warning: read fails\n");
						continue;
					}

					if ((unsigned int)ret < lba_count){
						fprintf(stderr, 
							"warning: reading %u blks"
							" but only %u written\n", 
							lba_count, ret);
					}


					bcount = ret * 
						info.zbd_logical_block_size;
					iocount = 1;
				}

				elapsed = zbc_read_zone_usec() - elapsed;

				if ( elapsed ) {
					printf("Read %llu B (%llu I/Os) in %llu.%03llu sec\n",
					       bcount,
					       iocount,
					       elapsed / 1000000,
					       (elapsed % 1000000) / 1000);
					printf("  IOPS %llu\n",
					       iocount * 1000000 / elapsed);
					brate = bcount * 1000000 / elapsed;
					printf("  BW %llu.%03llu MB/s\n",
					       brate / 1000000,
					       (brate % 1000000) / 1000);
				} else {
					printf("Read %llu B (%llu I/Os)\n",
					       bcount,
					       iocount);
				}
			}
		}
	}


out:

	if ( file && (fd > 0) ) {
		if ( fd != fileno(stdout) ) {
			close(fd);
		}
		if ( ret != 0 ) {
			unlink(file);
		}
	}

	if ( iobuf ) {
		free(iobuf);
	}

	if ( zones ) {
		free(zones);
	}

	zbc_close(dev);

	return( ret );

out_failure:
	if(job.tasks != NULL)
		free(job.tasks);
	return 1;


}

