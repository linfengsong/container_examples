#!/usr/bin/env python

"""Tests for `gitlab_cicd_utils` package."""

import pytest
from gitlab_cicd_utils import gitlab_cicd_utils


@pytest.fixture
def response():
    """Sample pytest fixture.

    See more at: http://doc.pytest.org/en/latest/fixture.html
    """
    # import requests
    # return requests.get('https://github.com/audreyr/cookiecutter-pypackage')


def test_content(response):
    """Sample pytest test function with the pytest fixture as an argument."""
    # from bs4 import BeautifulSoup
    # assert 'GitHub' in BeautifulSoup(response.content).title.string


def test_hello_world():
    gitlab_cicd_utils.hello_world()
