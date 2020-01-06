#!/usr/bin/python
# -*- coding: utf-8 -
import random
from datetime import timedelta

from faker import Factory
from faker.providers.company.en_US import Provider as CompanyProviderEnUs
from faker.providers.company.ru_RU import Provider as CompanyProviderRuRu
from munch import munchify

from data.op_faker.op_faker import OP_Provider
from local_time import get_now

fake_en = Factory.create(locale='en_US')
fake_ru = Factory.create(locale='ru_RU')
fake_uk = Factory.create(locale='uk_UA')
fake_uk.add_provider(OP_Provider)
fake = fake_uk
used_identifier_id = []
mode_open =     ["belowThreshold", "aboveThresholdUA", "aboveThresholdEU",
                "aboveThresholdUA.defense", "competitiveDialogueUA", "competitiveDialogueEU", "esco"]
mode_limited =  ["reporting", "negotiation.quick", "negotiation"]
violationType = ["corruptionDescription", "corruptionProcurementMethodType", "corruptionChanges",
                "corruptionPublicDisclosure", "corruptionBiddingDocuments", "documentsForm",
                "corruptionAwarded", "corruptionCancelled", "corruptionContracting"]

# This workaround fixes an error caused by missing "catch_phrase" class method
# for the "ru_RU" locale in Faker >= 0.7.4
fake_ru.add_provider(CompanyProviderEnUs)
fake_ru.add_provider(CompanyProviderRuRu)


def create_fake_sentence():
    return fake.sentence(nb_words=10, variable_nb_words=True)


def create_fake_funder():
    return fake.funders_data()


def get_fake_funder_scheme():
    return fake.funder_scheme()


def create_fake_amount(award_amount):
    return round(random.uniform(1, award_amount), 2)


def create_fake_number(min_number, max_number):
    return random.randint(int(min_number), int(max_number))


def create_fake_float(min_number, max_number):
    return random.uniform(float(min_number), float(max_number))


def create_fake_title():
    return u"[ТЕСТУВАННЯ] {}".format(fake.title())


def create_fake_date():
    return get_now().isoformat()


def create_fake_period(days=0, hours=0, minutes=0):
    data = {
        "startDate": get_now().isoformat(),
        "endDate": (get_now() + timedelta(days=days, hours=hours, minutes=minutes)).isoformat()
    }
    return data


def subtraction(value1, value2):
    if "." in str (value1) or "." in str (value2):
        return (float (value1) - float (value2))
    else:
        return (int (value1) - int (value2))


def create_fake_value_amount():
    return fake.random_int(min=1)


def get_number_of_minutes(days, accelerator):
    return 1440 * int(days) / accelerator


def field_with_id(prefix, sentence):
    return u"{}-{}: {}".format(prefix, fake.uuid4()[:8], sentence)


"""Method for data criteria"""



def data_for_criteria(scheme='ДК021'):
    data = fake.fake_item(scheme)
    data_json = munchify(
        {
            "name": fake_uk.name(),
            "nameEng": fake_en.name(),
            "classification": {
                "id": data["classification"]["id"],
                "scheme": "ДК021",
                "description": data["classification"]["description"]
            },
            "additionalClassification": {
                "id": data["additionalClassifications"][0]["id"],
                "scheme": data["additionalClassifications"][0]["scheme"],
                "description": data["additionalClassifications"][0]["description"],
            },
            "minValue": str(create_fake_float(0, 10)),
            "maxValue": str(create_fake_float(11, 42)),
            "dataType": random.choice(['number', 'integer', 'boolean', 'string']),
            "unit": {
                "name": data['unit']['name'],
                "code": data['unit']['code']
            }
        }
    )
    return data_json


def data_for_edit():
    data = munchify(
        {
            "name": fake_uk.name(),
            "nameEng": fake_en.name(),
            "minValue": str(create_fake_float(0, 22)),
            "maxValue": str(create_fake_float(43, 54)),
            "status": "active"
        }
    )
    return data
