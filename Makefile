PROJECT = marvin
PROJECT_ROOT = $(PWD)

include Makefile.config

MEX    = $(MATLAB_ROOT)/bin/mex
NVCC   = $(CUDA_ROOT)/bin/nvcc
NVLINK = $(CUDA_ROOT)/bin/nvlink

NVCC_FLAGS   = -O3 -std=c++11 \
			   -gencode $(CUDA_GENCODE) \
 			   -D_MWAITXINTRIN_H_INCLUDED \
			   -DDATATYPE=$(MARVIN_DATATYPE) \
 			   -I$(CUDA_ROOT)/include \
			   -I$(CUDNN_ROOT)/include 

NVLINK_FLAGS = -L$(CUDA_ROOT)/lib64  -lcudart -lcublas -lcurand \
               -L$(CUDNN_ROOT)/lib64 -lcudnn

ifeq ($(USE_OPENCV), 1)
	ifeq ($(USE_PKGCONFIG), 1)
		NVCC_FLAGS   += `pkg-config --cflags      opencv` -DUSE_OPENCV
		NVLINK_FLAGS += `pkg-config --libs-only-L opencv`
	endif
	NVLINK_FLAGS += -lopencv_imgproc -lopencv_highgui
endif

ifeq ($(USE_EXTERNAL_CAFFE), 1)
	CAFFE_ROOT = $(EXTERNAL_CAFFE_ROOT)
else
	CAFFE_ROOT = $(PROJECT_ROOT)/caffe
endif

all: marvin tools

marvin: marvin.cu
	@echo "=> Building $(PROJECT)..."
	@echo "NVCC $^"
	@$(NVCC) $^ -o $@ $(NVCC_FLAGS) $(NVLINK_FLAGS)

tools: caffe tensorio

tensorio: half2float float2half

half2float: tools/tensorIO_matlab/float2half.cpp
	@echo "=> Building tensorIO::float2half..."
	@echo "MEX $^"
	@$(MEX) $^ -outdir tools/tensorIO_matlab

float2half: tools/tensorIO_matlab/float2half.cpp
	@echo "=> Building tensorIO::float2half..."
	@echo "MEX $^"
	@$(MEX) $^ -outdir tools/tensorIO_matlab

caffe: setup_caffe
	@echo "=> Building Caffe and caffemodel2marvin..."
	$(MAKE) $(MAKEFLAGS) -C $(CAFFE_ROOT) -j$(CAFFE_BUILD_JOBS)

restore_caffe:
	@echo "<= Restoring all the hacks on Caffe..."
	@git -C $(CAFFE_ROOT) reset --hard

cleanup_caffe: restore_caffe
	@echo "<= Cleaning up perious Caffe build..."
	$(MAKE) -C $(CAFFE_ROOT) clean
	git -C $(CAFFE_ROOT) clean -fd

setup_caffe: restore_caffe
	@echo "=> Hacking $(CAFFE_ROOT)/Makefile"
	@sed -i.origin "s/hdf5/hdf5_serial/g" $(CAFFE_ROOT)/Makefile
	@echo "=> Coping Makefile.config"
	@cp $(PROJECT_ROOT)/caffe.makefile.config $(CAFFE_ROOT)
	@echo "=> Injecting tools"
	@cp $(PROJECT_ROOT)//tools/converter_caffe/caffemodel2marvin.cpp $(CAFFE_ROOT)/tools

clean: cleanup_caffe
	@echo "<= Removing $(PROJECT)..."
	@rm -rf $(PROJECT)