# OpenALPR Conda Package

Conda recipe for [OpenALPR](https://github.com/openalpr/openalpr) on Linux.

# Setup

For development work, you'll need to create an Anaconda environment:
```bash
$ conda create -y -n test-env python==3.7 numpy matplotlib conda-build
$ conda activate test-env
```

Everything that follows assumes that the environment `test-env` has been activated.

Next, clone and [build](https://docs.conda.io/projects/conda-build/en/latest/install-conda-build.html) the `openalpr` recipe:
```bash
(test-env) $ git clone git@github.com:CityBaseInc/conda-openalpr.git
(test-env) $ conda build -c conda-forge conda-openalpr
(test-env) $ conda install --use-local -c conda-forge conda-openalpr
```
