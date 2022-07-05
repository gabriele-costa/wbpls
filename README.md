# Introduction

Watermarking-Based Physical-Level Security (WBPLS) is a model checking tool for the verification of security protocols using physical channel protection primitives called *watermarking* and *jamming*.

This repository contains the ProVerif theory and the models of the protocols described in the paper 
> [G. Costa, P. Degano, L. Galletta and S. Soderi. Watermarking and jamming primitives reshape security protocols](), Manuscript submitted for publication, 2022.

# Requirement

This project requires:
- [ProVerif >= 2.04](https://bblanche.gitlabpages.inria.fr/proverif/) the ProVerif automatic cryptographic protocol verifier;
- [m4](https://www.gnu.org/software/m4/) The GNU m4 macro processor.

# Structure of the repository

Here is a high level description of the content of the repository.

```text
.
├── Needham-Schroeder-simpled.pro
│   The ProVerif model of the Needham Schroeder protocol which uses watermarking and jamming instead of cryptography. 
│
├── parking.pro
│   The ProVerif model of the smart parking case study.
│
├── wbpls.pvt
│   The ProVerif theory that implements watermarking and jamming primitive.   
│
├── LICENSE
│
└── README.md
```

# Execution

We extended the ProVerif specification language with new primitives to express watermarking and jamming that can be directly used by protocol designers.
For the actual verification via ProVerif, designers need to compile the extended ProVerif specification to a standard one using `m4`:  

```bash
$ m4 --define=InRange [wbpls-model] > [proverif-model]
```

The option `--define=InRange` specifies that the attacker is inside the jamming range. 
If no option is given, the attacker is assumed to be outside the jamming range. 

For example, assume that `prot_spec.pro` is an extended ProVerif specification using watermarking and jamming. 
The following commands allows you to verify it:

```bash
$ m4 --define=InRange prot_spec.pro > prot_spec.pv
$ proverif -in pitype prot_spec.pv
```

# Experiments of the paper

Here are the instructions to reproduce the experiments described in the paper.

## Needham-Schroeder protocol

```bash
$ m4 --define=InRange Needham-Schroeder-simpled.pro > Needham-Schroeder-simpled.pv
$ proverif -in pitype Needham-Schroeder-simpled.pv
```

## Smart parking case study

```bash
$ m4 --define=InRange parking.pro > parking.pv
$ proverif -in pitype parking.pv
```