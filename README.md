# YANG 2.0

This is the repository for the document `draft-yn-netmod-yang2`
(The YANG 2.0 Data Modeling Language).

The initial initial goal is to make RFC 7950 not be XML or NETCONF specific,
thus setting a baseline for subsequent changes.  This is accomplished by:
  - removing the "XML Encoding Rules" sections.
  - removing the "NETCONF &ltl;edit-config&gt; Operations" sections.
  - removing the "NETCONF XML Encoding Rules" sections.
  - removing the "Example Usage" sections.
  - making remaining examples be both XML and JSON.

XML-specific text moves to `draft-yn-netmod-yang-xml` (XML Encoding
of Data Modeled with YANG).


## Build Artifacts and Diffs

https://netmod-wg.github.io/yang2

GitHub workflow actions are used to automatically build, test, and
publish the three drafts, in the `html`, `txt`, and `xml` formats.
This automation occur for both the `main` branch and every PR-branch.

The webpage also provide links to:
  - diff the `main` branch against RFC 7950.
  - diff the `main` branch against Datatracker.
  - diff a PR-branch against the `main` branch.


## Contributing

All contributions are made using pull requests (PRs).

Please see the [contributing](https://github.com/netmod-wg/yang2/blob/main/CONTRIBUTING.md) page for details.


## Command Line Usage

Formatted text and HTML versions of the draft can be built using `make`.

```sh
$ make clean && make
```

Command line usage requires that you have the necessary software installed.
You will need `make`, `python`, `xml2rfc`, and `rfcfold`.
