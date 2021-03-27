CC=gcc
CPP=g++
FC=gfortran
LIB=-lmagma
LINKER=ld
MAGMA=/p/software/juwelsbooster/stages/2020/software/magma/2.5.4-gcccoremkl-9.3.0-2020.2.254
FORTRAN=/p/software/juwelsbooster/stages/2020/software/GCCcore/9.3.0/lib64
GLIB=/p/software/juwelsbooster/stages/2020/software/GCCcore/9.3.0/lib64

runtests : src/magma_cpu.o src/magma_cpu_f.o src/magma_gpu.o src/magma_dgemm_gpu.o src/magma_dgemm_async_gpu.o src/test/runtests.o bindir
	${FC} src/magma_cpu.o src/magma_gpu.o src/magma_dgemm_gpu.o src/magma_dgemm_async_gpu.o src/test/runtests.o src/magma_cpu_f.o src/magma_interface.f90  -o ./bin/runtests -J./src -L${GLIB} -lstdc++ -I${MAGMA}/include -L${MAGMA}/lib ${LIB}

bindir : 
	mkdir -p ./bin

src/test/runtests.o :
	${CPP} -c src/test/runtests.cc -o src/test/runtests.o	

src/magma_cpu_f.o : 
	${FC} -c src/magma_cpu_f.f90 -o src/magma_cpu_f.o -J./src -I${MAGMA}/include -L${MAGMA}/lib ${LIB}

src/magma_cpu.o : 
	${CPP} -c src/magma_cpu.cc -o src/magma_cpu.o

src/magma_gpu.o : 
	${CPP} -c src/magma_gpu.cc -o src/magma_gpu.o

src/magma_dgemm_gpu.o : 
	${CPP} -c src/magma_dgemm_gpu.cc -o src/magma_dgemm_gpu.o

src/magma_dgemm_async_gpu.o : 
	${CPP} -c src/magma_dgemm_async_gpu.cc -o src/magma_dgemm_async_gpu.o

clean : 
	rm bin/runtests src/test/runtests.o src/magma_cpu.o src/magma_gpu.o src/magma_dgemm_gpu.o src/magma_dgemm_async_gpu.o src/magma_cpu_f.o fortmodule.mod fortinterface.mod
