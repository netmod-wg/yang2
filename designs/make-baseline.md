# Design for creating the "yang2" document

## Background

RFC 7950 contains details not specific to data-modeling that should be
factored out into other documents.  The resulting document, would be a
good basis for YANG 2.0.

## General Steps

1) Copy `rfc7950.xml` to `draft-yn-netmod-yang2.xml`

  - Note that file `rfc7950.xml` is from the Editor and was updated
    to `v3` using `xml2rfc --v2v3`.

2) Move XML-encoding details to `draft-yn-netmod-yang-xml.xml`.

  - The `yang-xml` document is in a different GitHub repo, here:
    https://github.com/netmod-wg/yang-xml.

  - There are XML-comments in `draft-yn-netmod-yang-xml.xml` that
    point to where content was pulled from in this document.

3) Delete any NETCONF-specific details 

  - It is expected that the NETCONF WG will examine this PR's diff
    as part of some future NETCONF-next effort.

