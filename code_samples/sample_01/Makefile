THREADS?=1

all: run

compile: omp_merge_sort.c
	gcc -Wall $< -o omp_merge_sort.exe -fopenmp

submit: 
	sbatch ./submit.slurm

run: compile
	export OMP_NUM_THREADS=$(THREADS) && ./omp_merge_sort.exe

clean:
	rm -f omp_merge_sort.exe