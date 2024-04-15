from mage_ai.settings.repo import get_repo_path
from mage_ai.io.bigquery import BigQuery
from mage_ai.io.config import ConfigFileLoader
from pandas import DataFrame
from os import path

if 'data_exporter' not in globals():
    from mage_ai.data_preparation.decorators import data_exporter


@data_exporter
def export_data_to_big_query(df: DataFrame, **kwargs) -> None:
    """
    Template for exporting data to a BigQuery warehouse.
    Specify your configuration settings in 'io_config.yaml'.

    Docs: https://docs.mage.ai/design/data-loading#bigquery
    """
    project_id = "de-traffic-couting-paris"
    dataset_name = "traffic_counting"
    table_name = "traffic_counting_data_raw"
    table_id = f"{project_id}.{dataset_name}.{table_name}"
    config_path = path.join(get_repo_path(), 'io_config.yaml')
    config_profile = 'default'

    
    kwarg_logger = kwargs.get('logger')
    kwarg_logger.info(f"Export to BQ under  {table_id}")

    BigQuery.with_config(ConfigFileLoader(config_path, config_profile)).export(
        df,
        table_id,
        if_exists='append',  # Specify resolution policy if table name already exists
    )
