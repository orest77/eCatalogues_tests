# -*- coding: utf-8 -*-
from faker.generator import random
from faker.providers import BaseProvider
from copy import deepcopy
from munch import Munch
import random
from json import load
import os


def load_data_from_file(file_name):
    if not os.path.exists(file_name):
        file_name = os.path.join(os.path.dirname(__file__), file_name)
    with open(file_name) as file_obj:
        if file_name.endswith(".json"):
            return Munch.fromDict(load(file_obj))
        elif file_name.endswith(".yaml"):
            return Munch.fromYAML(file_obj)


class OP_Provider(BaseProvider):
    _fake_data = load_data_from_file("op_faker_data.json")
    word_list = _fake_data.words
    procuringEntities = _fake_data.procuringEntities
    funders = _fake_data.funders
    funders_scheme_list = _fake_data.funders_scheme
    addresses = _fake_data.addresses
    classifications = _fake_data.classifications
    cpvs = _fake_data.cpvs
    moz_cpvs = _fake_data.moz_cpvs
    items_base_data = _fake_data.items_base_data
    rationale_types = _fake_data.rationale_types
    units = _fake_data.units

    @classmethod
    def randomize_nb_elements(self, number=10, le=60, ge=140):
        """
        Returns a random value near number.

        :param number: value to which the result must be near
        :param le: lower limit of randomizing (percents). Default - 60
        :param ge: upper limit of randomizing (percents). Default - 140
        :returns: a random int in range [le * number / 100, ge * number / 100]
            with minimum of 1
        """
        if le > ge:
            raise Exception("Lower bound: {} is greater then upper: {}.".format(le, ge))
        return int(number * self.random_int(min=le, max=ge) / 100) + 1

    @classmethod
    def word(self):
        """
        :example 'Курка'
        """
        return self.random_element(self.word_list)

    @classmethod
    def words(self, nb=3):
        """
        Generate an array of random words
        :example: array('Надіньте', 'фуражка', 'зелено')
        :param nb: how many words to return
        """
        return random.sample(self.word_list, nb)

    @classmethod
    def sentence(self, nb_words=5, variable_nb_words=True):
        """
        Generate a random sentence
        :example: 'Курка надіньте пречудовий зелено на.'
        :param nb_words: how many words the sentence should contain
        :param variable_nb_words: set to false if you want exactly $nbWords returned,
            otherwise $nbWords may vary by +/-40% with a minimum of 1
        """
        if nb_words <= 0:
            return ''

        if variable_nb_words:
            nb_words = self.randomize_nb_elements(number=nb_words)

        words = self.words(nb_words)
        words[0] = words[0].title()

        return " ".join(words) + '.'

    @classmethod
    def title(self):
        return self.sentence(nb_words=3)

    @classmethod
    def description(self):
        return self.sentence(nb_words=10)

    @classmethod
    def procuringEntity(self):
        return deepcopy(self.random_element(self.procuringEntities))

    @classmethod
    def funders_data(self):
        return self.random_element(self.funders)

    @classmethod
    def funder_scheme(self):
        return self.random_element(self.funders_scheme_list)

    @classmethod
    def cpv(self, cpv_group=None):
        if cpv_group:
            cpvs = []
            for cpv_element in self.cpvs:
                if cpv_element.startswith(cpv_group):
                    cpvs.append(cpv_element)
            return self.random_element(cpvs)
        else:
            return self.random_element(self.cpvs)


    @classmethod
    def fake_item(self, scheme_group):
        # """
        # Generate a random item for criteria
        scheme_group = str(scheme_group)
        similar_scheme = []
        actual_schema = ['ДК021', 'CPV_EN', 'CPV_RU', 'ДК003', ' ДК015', 'ДК018', 'КЕКВ', 'NONE', 'specialNorms', 'UA-ROAD', 'GMDN']

        for scheme_element in self.classifications:
            if scheme_element["classification"]["scheme"].startswith(scheme_group) \
                    and scheme_element["additionalClassifications"][0]["scheme"] in actual_schema \
                    and len(scheme_element["additionalClassifications"][0]["id"]) <= 10:
                similar_scheme.append(scheme_element)
        scheme = random.choice(similar_scheme)

        similar_units = []
        for unit_element in self.units:
            similar_units.append(unit_element)
        unit = random.choice(similar_units)

        data = dict(scheme)
        data['unit'] = unit

        return deepcopy(data)