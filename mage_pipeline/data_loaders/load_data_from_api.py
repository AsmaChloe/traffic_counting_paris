import io
import pandas as pd
import requests
if 'data_loader' not in globals():
    from mage_ai.data_preparation.decorators import data_loader
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test
import json 
from datetime import datetime, timedelta
import urllib.parse
from mage_ai.data_preparation.variable_manager import set_global_variable
import math 

@data_loader
def load_data_from_api(*args, **kwargs):
    """
    Template for loading data from API
    """
    execution_date = kwargs['execution_date']
    execution_date = execution_date.replace(year=execution_date.year - 1) #TODO a supprimer

    execution_date_hour_only = execution_date.replace(minute=0, second=0, microsecond=0)
    
    date_start = execution_date_hour_only
    date_end = date_start.replace(hour=date_start.hour + 1)

    set_global_variable(kwargs['pipeline_uuid'], 'date_start', date_start)
    set_global_variable(kwargs['pipeline_uuid'], 'date_end', date_end)

    print(f"Fetch data from {date_start} to {date_end}")

    # Original condition
    condition = f"t_1h >= date'{date_start}' and t_1h < date'{date_end}'"

    # Encode the condition
    encoded_condition = urllib.parse.quote(condition, safe="'")

    # Fetch total counts of records
    url = f"https://opendata.paris.fr/api/explore/v2.1/catalog/datasets/comptages-routiers-permanents/records?where={encoded_condition}&order_by=t_1h%20desc&limit=0"
    response = requests.get(url)
    data = json.loads(response.text)
    total_count = data['total_count']
    print(total_count)

    offsets = [ i * 100 for i in range(math.ceil(total_count/100))]
    results = []
    for offset in offsets :
        url = f"https://opendata.paris.fr/api/explore/v2.1/catalog/datasets/comptages-routiers-permanents/records?where={encoded_condition}&order_by=t_1h%20desc&limit=100&offset={offset}"
        response = requests.get(url)
        data = json.loads(response.text)
        results.append(pd.DataFrame(data['results']))

    return pd.concat(results)

@test
def test_output(output, *args) -> None:
    """
    Template code for testing the output of the block.
    """

    assert output is not None, 'The output is undefined'