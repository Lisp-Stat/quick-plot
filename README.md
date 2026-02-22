<!-- PROJECT SHIELDS -->

[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MS-PL License][license-shield]][license-url]
[![LinkedIn][linkedin-shield]][linkedin-url]



<!-- PROJECT LOGO -->
<br />
<p align="center">
  <a href="https://github.com/lisp-stat/lisp-stat">
    <img src="https://lisp-stat.dev/images/stats-image.svg" alt="Logo" width="80" height="80">
  </a>

  <h3 align="center">Quick Plot for Common Lisp</h3>

  <p align="center">
    Composable, ggplot-style plotting helpers for Lisp-Stat
    <br />
    <a href="https://lisp-stat.dev/docs/"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/lisp-stat/quick-plot/issues">Report Bug</a>
    ·
    <a href="https://github.com/lisp-stat/quick-plot/issues">Request Feature</a>
    ·
    <a href="https://lisp-stat.github.io/quick-plot/">Reference Manual</a>
  </p>
</p>



<!-- TABLE OF CONTENTS -->
<details open="open">
  <summary><h2 style="display: inline-block">Table of Contents</h2></summary>
  <ol>
    <li>
      <a href="#about-the-project">About the Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#resources">Resources</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About the Project

Quick Plot provides composable helper functions for building [Vega-Lite](https://vega.github.io/vega-lite/) plot specifications in Common Lisp.  Inspired by R's [ggplot2](https://ggplot2.tidyverse.org/), plots are constructed by combining independent layers — geometry, labels, scales, coordinates and themes — rather than writing monolithic JSON-like plists by hand.

The system is organized into three packages.  The `geom` package provides mark types (`point`, `bar`, `histogram`, `box-plot`, `line`), each responsible for encoding data fields into a single visual form.  The `gg` package provides layering modifiers (`label`, `axes`, `coord`, `theme`, `tooltip`) that control everything around the marks.  The `qplot` package provides a single `qplot` function that collapses plot definition, registration and rendering into one call for interactive REPL use.

Every helper returns a plist fragment.  A recursive `merge-plists` combines them into a single Vega-Lite spec.  A mark function never sets axis titles; `label` never touches encodings; `theme` never alters mark types.  This separation means any helper can be used with any plot type, and layers can be added, removed or swapped without affecting the rest of the specification.


### Built With

* [plot](https://github.com/Lisp-Stat/plot)
* [data-frame](https://github.com/Lisp-Stat/data-frame)
* [alexandria](https://gitlab.common-lisp.net/alexandria/alexandria)
* [alexandria+](https://github.com/Symbolics/alexandria-plus)


<!-- GETTING STARTED -->
## Getting Started

To get a local copy up and running follow these steps:

### Prerequisites

An ANSI Common Lisp implementation. Developed and tested with [SBCL](https://www.sbcl.org/).

### Installation

#### Getting the source

To make the system accessible to [ASDF](https://common-lisp.net/project/asdf/) (a build facility, similar to `make` in the C world), clone the repository in a directory ASDF knows about.  By default the `common-lisp` directory in your home directory is known.  Create this if it doesn't already exist and then:

1. Clone the repositories
```sh
cd ~/common-lisp && \
git clone https://github.com/Lisp-Stat/quick-plot
```
2. Reset the ASDF source-registry to find the new system (from the REPL)
   ```lisp
   (asdf:clear-source-registry)
   ```
3. Load the system
   ```lisp
   (asdf:load-system :quick-plot)
   ```

If you have installed the slime ASDF extensions, you can invoke this with a comma (',') from the slime REPL.

#### Getting dependencies

To get the third party systems that `quick-plot` depends on, you can use a dependency manager, such as [Quicklisp](https://www.quicklisp.org/beta/) or [CLPM](https://www.clpm.dev/). Once installed, get the dependencies with either of:

```lisp
(clpm-client:sync :sources "quick-plot") ;sources may vary
```

```lisp
(ql:quickload :quick-plot)
```

You need do this only once. After obtaining the dependencies, you can
load the system with `ASDF` as described above without first syncing
sources.


<!-- USAGE EXAMPLES -->
## Usage

Import the helper functions and load the Vega example datasets:

```lisp
(vega:load-vega-examples)

(import '(geom:point geom:bar geom:histogram geom:box-plot geom:line))
(import '(gg:label gg:axes gg:coord gg:theme gg:tooltip))
(import '(qplot:qplot))
```

Create a scatter plot with color encoding and axis labels:

```lisp
(qplot 'cars vgcars
  `(:title "Horsepower vs. Fuel Efficiency")
   (point :horsepower :miles-per-gallon
          :color :origin :filled t)
   (label :x "Horsepower" :y "Miles per Gallon"))
```

Create a histogram of a quantitative variable:

```lisp
(qplot 'mpg-dist vgcars
  `(:title "Distribution of Miles per Gallon")
   (histogram :miles-per-gallon :color "darkslategray")
   (label :x "Miles per Gallon" :y "Count"))
```

Create a bar chart with aggregation:

```lisp
(qplot 'avg-mpg vgcars
  `(:title "Average MPG by Origin")
   (bar :origin :miles-per-gallon :aggregate :mean)
   (label :x "Origin" :y "Mean MPG"))
```

For more examples, please refer to the
[Documentation](https://lisp-stat.dev/docs/cookbooks/quick-plot/).


<!-- ROADMAP -->
## Roadmap

See the [open issues](https://github.com/lisp-stat/quick-plot/issues) for a list of proposed features (and known issues).

## Resources

This system is part of the [Lisp-Stat](https://lisp-stat.dev/) project; that should be your first stop for information. Also see the [resources](https://lisp-stat.dev/docs/resources) and [community](https://lisp-stat.dev/community) page for more information.

<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to be learn, inspire, and create.  Any contributions you make are **greatly appreciated**.  Please see [CONTRIBUTING](CONTRIBUTING.md) for details on the code of conduct, and the process for submitting pull requests.

<!-- LICENSE -->
## License

Distributed under the MS-PL License. See [LICENSE](LICENSE) for more information.



<!-- CONTACT -->
## Contact

Project Link: [https://github.com/lisp-stat/quick-plot](https://github.com/lisp-stat/quick-plot)



<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/lisp-stat/quick-plot.svg?style=for-the-badge
[contributors-url]: https://github.com/lisp-stat/quick-plot/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/lisp-stat/quick-plot.svg?style=for-the-badge
[forks-url]: https://github.com/lisp-stat/quick-plot/network/members
[stars-shield]: https://img.shields.io/github/stars/lisp-stat/quick-plot.svg?style=for-the-badge
[stars-url]: https://github.com/lisp-stat/quick-plot/stargazers
[issues-shield]: https://img.shields.io/github/issues/lisp-stat/quick-plot.svg?style=for-the-badge
[issues-url]: https://github.com/lisp-stat/quick-plot/issues
[license-shield]: https://img.shields.io/github/license/lisp-stat/quick-plot.svg?style=for-the-badge
[license-url]: https://github.com/lisp-stat/quick-plot/blob/master/LICENSE
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://www.linkedin.com/company/symbolics/