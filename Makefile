CC=g++
FC=gfortran
LIB=-lmagma
MAGMA=/p/software/juwelsbooster/stages/2020/software/magma/2.5.4-gcccoremkl-9.3.0-2020.2.254

runtests : src/test/runtests.o src/magma_cpu.o src/magma_cpu_f.o src/magma_gpu.o src/magma_dgemm_gpu.o src/magma_dgemm_async_gpu.o bindir
	${CC} -o ./bin/runtests src/test/runtests.o src/magma_cpu.o src/magma_gpu.o src/magma_dgemm_gpu.o src/magma_dgemm_async_gpu.o ${LIB}

bindir : 
	mkdir -p ./bin

src/test/runtests.o : 
	${CC} -c src/test/runtests.cc -o src/test/runtests.o	

src/magma_cpu_f.o : 
	${CC} -c src/magma_cpu_f.f90 -o src/magma_cpu_f.o -I${MAGMA}/include -L${MAGMA}/lib ${LIB}

src/magma_cpu.o : 
	${CC} -c src/magma_cpu.cc -o src/magma_cpu.o

src/magma_gpu.o : 
	${CC} -c src/magma_gpu.cc -o src/magma_gpu.o

src/magma_dgemm_gpu.o : 
	${CC} -c src/magma_dgemm_gpu.cc -o src/magma_dgemm_gpu.o

src/magma_dgemm_async_gpu.o : 
	${CC} -c src/magma_dgemm_async_gpu.cc -o src/magma_dgemm_async_gpu.o

clean : 
	rm bin/runtests src/test/runtests.o src/magma_cpu.o src/magma_gpu.o src/magma_dgemm_gpu.o src/magma_dgemm_async_gpu.o src/magma_cpu_f.o
