CC=g++
LIB=-lmagma

runtests : src/test/runtests.o src/magma_cpu.o src/magma_gpu.o src/magma_dgemm_gpu.o bindir
	${CC} -o ./bin/runtests src/test/runtests.o src/magma_cpu.o src/magma_gpu.o src/magma_dgemm_gpu.o ${LIB}

bindir : 
	mkdir -p ./bin

src/test/runtests.o : 
	${CC} -c src/test/runtests.cc -o src/test/runtests.o	

src/magma_cpu.o : 
	${CC} -c src/magma_cpu.cc -o src/magma_cpu.o

src/magma_gpu.o : 
	${CC} -c src/magma_gpu.cc -o src/magma_gpu.o

src/magma_dgemm_gpu.o : 
	${CC} -c src/magma_dgemm_gpu.cc -o src/magma_dgemm_gpu.o

clean : 
	rm bin/runtests src/test/runtests.o src/magma_cpu.o src/magma_gpu.o src/magma_dgemm_gpu.o
