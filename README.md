# Testeroo

### Purpose

**Testeroo** is a web app that automates away the most repetitive and tedious aspects of QA work -- specifically, logging test results and keeping track of which tests satisfy a given metric's or (integration's) requirements.

The data structure consists of 6 primary tables:

* **Users**: Each record represents a tester from the QA team.
* **Metrics**: Each record represents a metric for a given ad format and environment.
* **Suites**: Each record represents an integration (or package) consisting of a distinct grouping of metrics that should be tested together.
* **Tests**: Each record represents a test case describing a specific action (or set of actions) to be taken by a QA tester, along with the expected result of that test.
* **Results**: Each record represents the results of an individual test that has been conducted: whether it passed or failed, when it was completed, and any associated notes.
* **Assignments**: Each record represents a mapping of tests to metrics, such that when all of a given metric's tests have passed, the metric itself has passed testing.
