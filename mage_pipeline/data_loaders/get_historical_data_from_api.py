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
from mage_ai.orchestration.triggers.api import trigger_pipeline

def round_down_hour(dt):
    return dt.replace(minute=0, second=0, microsecond=0)

def generate_hourly_intervals(start, end):
    intervals = []
    current_hour = start
    while current_hour < end:
        next_hour = current_hour + timedelta(hours=1)
        intervals.append((current_hour, next_hour))
        current_hour = next_hour
    return intervals


@data_loader
def load_data_from_api(*args, **kwargs):
    """
    Template for loading data from API
    """
    kwarg_logger = kwargs.get('logger')

    date_start = datetime.strptime(kwargs['date_start'], '%Y-%m-%dT%H:%M:%S')
    date_end = datetime.strptime(kwargs['date_end'], '%Y-%m-%dT%H:%M:%S')
    
    date_start_rounded_down = round_down_hour(date_start)
    date_end_rounded_down = round_down_hour(date_end)

    assert date_end_rounded_down <= datetime.today() - timedelta(days=1), "Assertion failed: Must be yesterday or any day before yesterday"

    kwarg_logger.info(f"Generate data from {date_start_rounded_down} to {date_end_rounded_down} (excluded)")
    hourly_intervals = generate_hourly_intervals(date_start_rounded_down, date_end_rounded_down)

    for start, end in hourly_intervals :
        trigger_pipeline(
            'api_to_gcs',        # Required: enter the UUID of the pipeline to trigger
            variables={'date_start' : start.strftime('%Y-%m-%dT%H:%M:%S'), 'date_end' : end.strftime('%Y-%m-%dT%H:%M:%S'), 'manually_launched' : True},           # Optional: runtime variables for the pipeline
            check_status=False,     # Optional: poll and check the status of the triggered pipeline
            error_on_failure=False, # Optional: if triggered pipeline fails, raise an exception
            poll_interval=60,       # Optional: check the status of triggered pipeline every N seconds
            poll_timeout=None,      # Optional: raise an exception after N seconds
            verbose=True,           # Optional: print status of triggered pipeline run
        )