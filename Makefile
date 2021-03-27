CC            = gcc
CPP           = g++
FC            = gfortran
LD            = gcc
CFLAGS        = -Wall
LDFLAGS       = -Wall
LIB           = -lmagma
LINKER        = ld
MAGMA         = /p/software/juwelsbooster/stages/2020/software/magma/2.5.4-gcccoremkl-9.3.0-2020.2.254
MAGMADIR      = /p/software/juwelsbooster/stages/2020/software/magma/2.5.4-gcccoremkl-9.3.0-2020.2.254
FORTRAN       = /p/software/juwelsbooster/stages/2020/software/GCCcore/9.3.0/lib64
GLIB          = /p/software/juwelsbooster/stages/2020/software/GCCcore/9.3.0/lib64
CUDADIR      ?= /p/software/juwelsbooster/stages/2020/software/CUDA/11.0
OPENBLASDIR  ?= /p/software/juwelsbooster/stages/2020/software/GCC/
MAGMA_CFLAGS   := -DADD_ -I$(MAGMADIR)/include -I$(CUDADIR)/include
MAGMA_F90FLAGS := -I$(MAGMADIR)/include -Dmagma_devptr_t="integer(kind=8)"

MAGMA_LIBS   := -L$(MAGMADIR)/lib -L$(CUDADIR)/lib64 -L$(OPENBLASDIR)/lib \
                -lmagma -lcublas -lcudart -lmkl

# ----------------------------------------
default:
	@echo "Available make targets are:"
	@echo "  make all       # compiles everything"
	@echo "  make clean     # deletes executables and object files"

all: runtests

clean : 
	-rm *.o *.mod src/*.o src/*.mod src/test/*.o rm bin/runtests 


# ----------------------------------------
runtests : fortran.o src/magma_cpu.o src/magma_cpu_f.o src/magma_gpu.o src/magma_gpu_f.o src/magma_dgemm_gpu.o src/magma_dgemm_gpu_f.o src/magma_dgemm_async_gpu.o src/test/runtests.o bindir
	${FC} $(MAGMA_F90FLAGS) $(LDFLAGS) fortran.o src/magma_cpu_f.o src/magma_gpu_f.o src/magma_cpu.o src/magma_gpu.o src/magma_dgemm_gpu.o src/magma_dgemm_gpu_f.o src/magma_dgemm_async_gpu.o src/test/runtests.o src/magma_interface.F90  -o ./bin/runtests -J./src $(MAGMA_LIBS) -L${GLIB} -lstdc++ #-I${MAGMA}/include -L${MAGMA}/lib ${LIB}

bindir : 
	mkdir -p ./bin

src/test/runtests.o :
	${CPP} -c src/test/runtests.cc -o src/test/runtests.o	

fortran.o: $(CUDADIR)/src/fortran.c
	$(CC) $(CFLAGS) $(MAGMA_CFLAGS) -DCUBLAS_GFORTRAN -c -o $@ $<

src/magma_gpu_f.o :
	${FC} $(MAGMA_F90FLAGS) -c src/magma_gpu_f.F90 -o src/magma_gpu_f.o -J./src -I${MAGMA}/include $(MAGMA_LIBS) #-L${MAGMA}/lib ${LIB}

src/magma_dgemm_gpu_f.o :
	${FC} $(MAGMA_F90FLAGS) -c src/magma_dgemm_gpu_f.F90 -o src/magma_dgemm_gpu_f.o -J./src -I${MAGMA}/include $(MAGMA_LIBS) #-L${MAGMA}/lib ${LIB}

src/magma_cpu_f.o :
	${FC} $(MAGMA_F90FLAGS) -c src/magma_cpu_f.F90 -o src/magma_cpu_f.o -J./src -I${MAGMA}/include $(MAGMA_LIBS) #-L${MAGMA}/lib ${LIB}

src/magma_cpu.o : 
	${CPP} $(CFLAGS) $(MAGMA_CFLAGS) -DCUBLAS_GFORTRAN -c src/magma_cpu.cc -o src/magma_cpu.o

src/magma_gpu.o : 
	${CPP} $(CFLAGS) $(MAGMA_CFLAGS) -DCUBLAS_GFORTRAN -c src/magma_gpu.cc -o src/magma_gpu.o

src/magma_dgemm_gpu.o : 
	${CPP} $(CFLAGS) $(MAGMA_CFLAGS) -DCUBLAS_GFORTRAN -c src/magma_dgemm_gpu.cc -o src/magma_dgemm_gpu.o

src/magma_dgemm_async_gpu.o : 
	${CPP} $(CFLAGS) $(MAGMA_CFLAGS) -DCUBLAS_GFORTRAN -c src/magma_dgemm_async_gpu.cc -o src/magma_dgemm_async_gpu.o
