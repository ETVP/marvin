# Marvin

> Marvin is a GPU-only neural network framework made with simplicity, hackability, speed, memory consumption, and high dimensional data in mind.

`ETVP/marvin` 是原项目的一个分支，旨在解决原有项目遗留的各种兼容性问题。本分支假设目标机器的环境为

+ Ubuntu 16.04
+ CUDA 8.0
+ cuDNN 5.1

并基于此假设重写了 `Makefile` 和对应的 `Makefile.config`。

## 获取与构建

`ETVP/marvin` 将 `BVLC/caffe` 作为一个 submodule 添加到当前项目。
以下过程将完全自动的构建`Marvin`和`Caffe`:

```shell
git clone --recursive https://github.com/ETVP/marvin.git
cd marvin
make
```

如有需要，请定制`Makefile.config`。

## MNIST

1. Prepare data: run examples/mnist/prepare_mnist.m in Matlab
2. Train a model: run ./examples/mnist/demo.sh in shell
3. Visualize filters: run examples/mnist/demo_vis_filter.m in Matlab

## Tutorials and Documentation
Please see our website at [http://marvin.is](http://marvin.is).

## Citation
The following is the citation of the current version of Marvin. Note that the reference may change in the future when new contributors join the project.

```latex
@misc{Marvin20151110,
      title        = {Marvin: A minimalist {GPU}-only {N}-dimensional {ConvNet} framework},
      author       = {Jianxiong Xiao and Shuran Song and Daniel Suo and Fisher Yu},
      howpublished = {\url{http://marvin.is}},
      note         = {Accessed: 2015-11-10}
}
```

## Acknowledgements
Marvin stands on the shoulders of others who have open-sourced their work. You can find the source code of their projects along with license information below. We acknowledge and are grateful to these developers and researchers for their contributions to open source.

- [Fast-RCNN](https://github.com/rbgirshick/fast-rcnn) ([License](https://github.com/rbgirshick/fast-rcnn/blob/master/LICENSE)) Copyright (c) Microsoft Corporation
- [Darknet](https://github.com/pjreddie/darknet) ([License](https://github.com/pjreddie/darknet/blob/master/LICENSE))
- [Caffe](https://github.com/BVLC/caffe/) ([License](https://github.com/BVLC/caffe/blob/master/LICENSE)) Copyright (c) 2014, 2015 The Regents of the University of California
- [Mocha.jl](https://github.com/pluskid/Mocha.jl) ([License](https://github.com/pluskid/Mocha.jl/blob/master/LICENSE.md)) Copyright (c) 2014 Chiyuan Zhuang
- [Fast Depth-RCNN](https://github.com/s-gupta/fast-rcnn/tree/distillation) ([License](https://github.com/s-gupta/fast-rcnn/blob/distillation/LICENSE_fast_rcnn)) Copyright (c) Microsoft Corporation
