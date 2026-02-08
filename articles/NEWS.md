# NEWS

## v0.0.7 (2026-02-09)

- cuppa: handle rna predsum
  ([pr170](https://github.com/umccr/tidywigits/pull/170),
  [iss169](https://github.com/umccr/tidywigits/issues/169))
- s3sync: add isofox + alignments md.metrics

## v0.0.6 (2026-02-04)

- Add Neo support
  ([pr152](https://github.com/umccr/tidywigits/pull/152),
  [iss144](https://github.com/umccr/tidywigits/issues/144))
- Add Peach support
  ([pr153](https://github.com/umccr/tidywigits/pull/153),
  [iss145](https://github.com/umccr/tidywigits/issues/145))
- Add Cider support
  ([pr155](https://github.com/umccr/tidywigits/pull/155),
  [iss147](https://github.com/umccr/tidywigits/issues/147))
- Add Teal support
  ([pr154](https://github.com/umccr/tidywigits/pull/154),
  [iss146](https://github.com/umccr/tidywigits/issues/146))
- Purple: handle v4.1
  ([pr150](https://github.com/umccr/tidywigits/pull/150),
  [iss141](https://github.com/umccr/tidywigits/issues/141))
- Bamtools: support gene/exon coverage files
  ([pr151](https://github.com/umccr/tidywigits/pull/151),
  [iss149](https://github.com/umccr/tidywigits/issues/149))
- Quarto Website setup for tidywigits outputs
  ([pr157](https://github.com/umccr/tidywigits/pull/157),
  [pr160](https://github.com/umccr/tidywigits/pull/160),
  [iss156](https://github.com/umccr/tidywigits/issues/156))
- Add optional redux prefix pattern for Alignments dupfreq
  ([iss161](https://github.com/umccr/tidywigits/issues/161),
  [pr164](https://github.com/umccr/tidywigits/pull/164))
- Add AWS S3 sync wrapper
  ([pr165](https://github.com/umccr/tidywigits/pull/165))
- Use renamed `input_id`/`input_pfix`/`diro` for `nemofy`
  ([pr166](https://github.com/umccr/tidywigits/pull/166))
- Metadata: override Workflow parent `get_metadata` method for pkg spec
  ([iss167](https://github.com/umccr/tidywigits/issues/167),
  [pr168](https://github.com/umccr/tidywigits/pull/168))

## v0.0.5 (2025-09-07)

- [v0.0.5 - v0.0.4
  diff](https://github.com/umccr/tidywigits/compare/v0.0.4...v0.0.5)

Major refactor, moving core functionality to
[nemo](https://github.com/umccr/nemo)

- move Config, Tool, Workflow classes to nemo
- move utils to nemo
- CLI: use nemo wrapper
- use conda env for pkgdown

## v0.0.4 (2025-08-19)

- [v0.0.4 - v0.0.3
  diff](https://github.com/umccr/tidywigits/compare/v0.0.3...v0.0.4)

Major documentation update - see
[pr138](https://github.com/umccr/tidywigits/pull/138) for details.

- test data update
- full README re-write
- pkgdown vignette re-org
- add vignettes for raw/tidy schemas, uml diagram
- add `pkgdown/extra.scss` for CSS customisation
- add logo

## v0.0.3 (2025-08-04)

- [v0.0.3 - v0.0.2
  diff](https://github.com/umccr/tidywigits/compare/v0.0.2...v0.0.3)

Fixed bug where `normalizePath` was getting called with NULL output
directory in the db format case
([pr133](https://github.com/umccr/tidywigits/pull/133)).

## v0.0.2 (2025-07-14)

- [v0.0.2 - v0.0.1
  diff](https://github.com/umccr/tidywigits/compare/v0.0.1...v0.0.2)

Mostly Shiny, Conda, Docker, pkgdown and GitHub Actions support.

- Add GitHub Actions for deployment of the following
  ([pr130](https://github.com/umccr/tidywigits/pull/130),
  [iss9](https://github.com/umccr/tidywigits/issues/9)):
  - Conda: add recipe and rattler-builder
    ([pr124](https://github.com/umccr/tidywigits/pull/124),
    [iss4](https://github.com/umccr/tidywigits/issues/4))
  - Docker: add Dockerfile
    ([pr130](https://github.com/umccr/tidywigits/pull/130))
  - Shiny: add summary app
    ([pr122](https://github.com/umccr/tidywigits/pull/122))
  - CLI: Add listing and tidy include/exclude support
    ([pr116](https://github.com/umccr/tidywigits/pull/116))
  - Add pkgdown support
    ([pr125](https://github.com/umccr/tidywigits/pull/125),
    [iss37](https://github.com/umccr/tidywigits/issues/37))
  - Add DVC support with some purple test data
    ([pr126](https://github.com/umccr/tidywigits/pull/126),
    [iss59](https://github.com/umccr/tidywigits/issues/59))
- Optimise file listing
  ([pr131](https://github.com/umccr/tidywigits/pull/131),
  [iss127](https://github.com/umccr/tidywigits/issues/127))
  - Remove `File` class

## v0.0.1 (2025-06-19)

Initial release of tidywigits.

- R pkg skeleton ([pr6](https://github.com/umccr/tidywigits/pull/6))
- Add `Config`, `File` and `Tool` classes
  ([pr12](https://github.com/umccr/tidywigits/pull/12))
- Add `Workflow` class
  ([pr99](https://github.com/umccr/tidywigits/pull/99),
  [iss97](https://github.com/umccr/tidywigits/issues/97))
- Add `Oncoanalyser` class
  ([pr52](https://github.com/umccr/tidywigits/pull/52),
  [pr101](https://github.com/umccr/tidywigits/pull/101),
  [iss39](https://github.com/umccr/tidywigits/issues/39))
- Add `bump-my-version`
  ([pr10](https://github.com/umccr/tidywigits/pull/10),
  [iss3](https://github.com/umccr/tidywigits/issues/3))
- Add `pre-commit` hooks
  ([pr8](https://github.com/umccr/tidywigits/pull/8),
  [iss2](https://github.com/umccr/tidywigits/issues/2))
- Add `Makefile` and `air.toml`
  ([pr7](https://github.com/umccr/tidywigits/pull/7))
- Support for main outputs from the following WiGiTS tools:
  - Alignments ([pr28](https://github.com/umccr/tidywigits/pull/28),
    [pr79](https://github.com/umccr/tidywigits/pull/79),
    [iss17](https://github.com/umccr/tidywigits/issues/17),
    [iss77](https://github.com/umccr/tidywigits/issues/77))
  - Amber ([pr14](https://github.com/umccr/tidywigits/pull/14),
    [iss13](https://github.com/umccr/tidywigits/issues/13))
  - Bamtools ([pr44](https://github.com/umccr/tidywigits/pull/44),
    [pr66](https://github.com/umccr/tidywigits/pull/66),
    [iss62](https://github.com/umccr/tidywigits/issues/62),
    [iss16](https://github.com/umccr/tidywigits/issues/16))
  - Chord ([pr29](https://github.com/umccr/tidywigits/pull/29),
    [pr38](https://github.com/umccr/tidywigits/pull/38),
    [iss18](https://github.com/umccr/tidywigits/issues/18),
    [iss38](https://github.com/umccr/tidywigits/issues/38))
  - Cobalt ([pr33](https://github.com/umccr/tidywigits/pull/33),
    [iss15](https://github.com/umccr/tidywigits/issues/15))
  - Cuppa ([pr30](https://github.com/umccr/tidywigits/pull/30),
    [pr68](https://github.com/umccr/tidywigits/pull/68),
    [iss19](https://github.com/umccr/tidywigits/issues/19),
    [iss67](https://github.com/umccr/tidywigits/issues/67))
  - Esvee ([pr87](https://github.com/umccr/tidywigits/pull/87),
    [iss61](https://github.com/umccr/tidywigits/issues/61))
  - Flagstats ([pr45](https://github.com/umccr/tidywigits/pull/45),
    [pr46](https://github.com/umccr/tidywigits/pull/46),
    [iss20](https://github.com/umccr/tidywigits/issues/20))
  - Isofox ([pr80](https://github.com/umccr/tidywigits/pull/80),
    [iss76](https://github.com/umccr/tidywigits/issues/76))
  - Lilac ([pr31](https://github.com/umccr/tidywigits/pull/31),
    [iss21](https://github.com/umccr/tidywigits/issues/21))
  - Linx ([pr50](https://github.com/umccr/tidywigits/pull/50),
    [pr89](https://github.com/umccr/tidywigits/pull/89),
    [iss22](https://github.com/umccr/tidywigits/issues/22),
    [iss88](https://github.com/umccr/tidywigits/issues/88))
  - Purple ([pr36](https://github.com/umccr/tidywigits/pull/36),
    [pr51](https://github.com/umccr/tidywigits/pull/51),
    [iss23](https://github.com/umccr/tidywigits/issues/23),
    [iss49](https://github.com/umccr/tidywigits/issues/49))
  - Sage ([pr48](https://github.com/umccr/tidywigits/pull/48),
    [pr72](https://github.com/umccr/tidywigits/pull/72),
    [pr73](https://github.com/umccr/tidywigits/pull/73),
    [iss24](https://github.com/umccr/tidywigits/issues/24),
    [iss71](https://github.com/umccr/tidywigits/issues/71),
    [iss57](https://github.com/umccr/tidywigits/issues/57))
  - Sigs ([pr47](https://github.com/umccr/tidywigits/pull/47),
    [iss25](https://github.com/umccr/tidywigits/issues/25))
  - Virusbreakend ([pr42](https://github.com/umccr/tidywigits/pull/42),
    [iss26](https://github.com/umccr/tidywigits/issues/26))
  - Virusinterpreter
    ([pr40](https://github.com/umccr/tidywigits/pull/40),
    [pr65](https://github.com/umccr/tidywigits/pull/65),
    [iss27](https://github.com/umccr/tidywigits/issues/27),
    [iss41](https://github.com/umccr/tidywigits/issues/41))
- Schema:
  - versioning ([pr64](https://github.com/umccr/tidywigits/pull/64),
    [iss43](https://github.com/umccr/tidywigits/issues/43))
  - guesser ([pr69](https://github.com/umccr/tidywigits/pull/69),
    [iss63](https://github.com/umccr/tidywigits/issues/63))
- Vignettes:
  - Setup ([pr92](https://github.com/umccr/tidywigits/pull/92),
    [iss60](https://github.com/umccr/tidywigits/issues/60))
- Tool:
  - write functionality
    ([pr98](https://github.com/umccr/tidywigits/pull/98),
    [iss95](https://github.com/umccr/tidywigits/issues/95))
  - optionally output raw parsed tibbles
    ([pr94](https://github.com/umccr/tidywigits/pull/94),
    [iss91](https://github.com/umccr/tidywigits/issues/91))
- UML diagram ([pr107](https://github.com/umccr/tidywigits/pull/107),
  [iss106](https://github.com/umccr/tidywigits/issues/106))
- DB schema ([pr111](https://github.com/umccr/tidywigits/pull/111),
  [iss110](https://github.com/umccr/tidywigits/issues/110))
- CLI support ([pr114](https://github.com/umccr/tidywigits/pull/114))
