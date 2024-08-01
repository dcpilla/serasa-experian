import boto3
import argparse
import psycopg2
from datetime import datetime

def write_cost_by_services(db_config,session,account_id):
    # Cria um cliente para o AWS Cost Explorer
    ce_client = session.client('ce')

    # Define o período de tempo para o mês corrente
    now = datetime.now()
    start_date = f"{now.year}-{now.month:02d}-01"
    end_date = f"{now.year}-{now.month:02d}-{now.day:02d}"

    cost_response = ce_client.get_cost_and_usage(
        TimePeriod={'Start': start_date, 'End': end_date},
        Granularity='MONTHLY',
        Metrics=["UnblendedCost","UsageQuantity"],
        GroupBy=[{"Type": "DIMENSION", "Key": "SERVICE"}]
    )

    # Iterar pelos grupos de serviços e extrair as métricas
    try:
        # Conectando ao banco de dados
        conn = psycopg2.connect(**db_config)

        cursor = conn.cursor()
        delete_query = f"""
            DELETE FROM resourcecost
            WHERE account_id = '{account_id}';
        """

        # Executando o comando
        cursor.execute(delete_query)
        conn.commit()
        print(f"Registros com account_id {account_id} excluídos com sucesso!")

        for group in cost_response['ResultsByTime'][0]['Groups']:
            service_name = group['Keys'][0]  # Nome do serviço
            unblended_cost_amount = group['Metrics']['UnblendedCost']['Amount']  # Custo não mesclado
            usage_quantity_amount = group['Metrics']['UsageQuantity']['Amount']  # Quantidade de uso

            # Imprimir os valores
            print(f"Serviço: {service_name}, Custo Não Mesclado: {unblended_cost_amount}, Quantidade de Uso: {usage_quantity_amount}")

            # Comando SQL para inserir os valores na tabela account
            insert_query = f"""
                INSERT INTO resourcecost (date_register,service,account_id,unblended_cost,usage_quantity)
                VALUES ('{now}','{service_name}','{account_id}','{unblended_cost_amount}','{usage_quantity_amount}');
            """
            cursor.execute(insert_query)
            conn.commit()

    except (Exception, psycopg2.Error) as error:
        # Caso ocorra erro no banco de dados
        print(f"Erro de banco de dados: {error}")
    finally:
        # Fechando a conexão
        if conn:
            cursor.close()
            conn.close()

# def write_cost_by_buckets(db_config,session,account_id):

#     s3_client = session.client('s3')
#     cw_client = session.client('cloudwatch')

#     # Define o período de tempo para o mês corrente
#     now = datetime.now()
#     start_date = f"{now.year}-{now.month:02d}-01"
#     end_date = f"{now.year}-{now.month:02d}-{now.day:02d}"

#     buckets_response = s3_client.list_buckets()
#     for bucket in buckets_response["Buckets"]:
#         bucket_name = bucket["Name"]
#         metric_response = cw_client.get_metric_statistics(
#             Namespace = 'AWS/S3',
#             MetricName = 'BucketSizeBytes',
#             Dimension =  [
#                 {'Name': 'BucketName','Value': bucket_name},
#                 {'Name': 'StorageType','Value': 'StandardStorage'}
#             ],
#         StartTime = 
#         )

    # for bucket in s3_list["Buckets"]:
    #     cost_response = ce_client.get_cost_and_usage(
    #         TimePeriod={'Start': start_date, 'End': end_date},
    #         Granularity='MONTHLY',
    #         Metrics=["UnblendedCost"],
    #         Filter={
    #             ("Dimensions",): {"Key": "S3_BUCKET_NAME", "Values": [bucket_name]}
    #         }

    #     )
    # s3_unblended_cost = cost_response['ResultsByTime'][0]['Total']['UnblendedCost']['Amount']
    #    write_cost_by_tag(db_config,account_id,bucket_name,type_tag,s3_unblended_cost)
#    print(cost_response)

# def write_cost_by_services(db_config,session,account_id):
#     # Cria um cliente para o AWS Cost Explorer
#     ce_client = session.client('ce')

#     # s3_list = s3_client.list_buckets()
#     # type_tag="Amazon Simple Storage Service"
    
#     # Define o período de tempo para o mês corrente
#     now = datetime.now()
#     start_date = f"{now.year}-{now.month:02d}-01"
#     end_date = f"{now.year}-{now.month:02d}-{now.day:02d}"

#     cost_response = ce_client.get_cost_and_usage(
#         TimePeriod={'Start': start_date, 'End': end_date},
#         Granularity='MONTHLY',
#         Metrics=["UnblendedCost","UsageQuantity"],
# #        Filter={
# #            "Dimensions": {"Key": "SERVICE", "Values": ["Amazon Simple Storage Service"]}
#             # Note: O filtro acima não filtrará custos por bucket individualmente.
#             # Isso requer uma estratégia de tags conforme explicado anteriormente.
# #        }
#         GroupBy=[{"Type": "DIMENSION", "Key": "SERVICE"}]
#     )

#     # Iterar pelos grupos de serviços e extrair as métricas
#     for group in cost_response['ResultsByTime'][0]['Groups']:
#         service_name = group['Keys'][0]  # Nome do serviço
#         unblended_cost_amount = group['Metrics']['UnblendedCost']['Amount']  # Custo não mesclado
#         usage_quantity_amount = group['Metrics']['UsageQuantity']['Amount']  # Quantidade de uso

#         # Imprimir os valores
#         print(f"Serviço: {service_name}, Custo Não Mesclado: {unblended_cost_amount}, Quantidade de Uso: {usage_quantity_amount}")

#     # for bucket in s3_list["Buckets"]:
#     #     bucket_name = bucket["Name"]
#     #     cost_response = ce_client.get_cost_and_usage(
#     #         TimePeriod={'Start': start_date, 'End': end_date},
#     #         Granularity='MONTHLY',
#     #         Metrics=["UnblendedCost"],
#     #         Filter={
#     #             ("Dimensions",): {"Key": "S3_BUCKET_NAME", "Values": [bucket_name]}
#     #         }

#     #     )
#     # s3_unblended_cost = cost_response['ResultsByTime'][0]['Total']['UnblendedCost']['Amount']
#     #    write_cost_by_tag(db_config,account_id,bucket_name,type_tag,s3_unblended_cost)
# #    print(cost_response)


def write_cost_by_account(db_config,session,account_id):
    # Cria um cliente para o AWS Cost Explorer
    ce_client = session.client('ce')

    # Define o período de tempo para o mês corrente
    now = datetime.now()
    start_date = f"{now.year}-{now.month:02d}-01"
    end_date = f"{now.year}-{now.month:02d}-{now.day:02d}"

    response = ce_client.get_cost_and_usage(
        TimePeriod={'Start': start_date, 'End': end_date},
        Granularity='MONTHLY',
        Metrics=["UnblendedCost"],
    )
    # print(response[0]['ResultsByTime']['Groups'])
    account_cost = response['ResultsByTime'][0]['Total']['UnblendedCost']['Amount']
    try:
        # Conectando ao banco de dados
        conn = psycopg2.connect(**db_config)
        cursor = conn.cursor()

        # Comando SQL para inserir os valores na tabela account
        # Verificando se o account_id já existe na tabela
        check_query = f"""
            SELECT FROM accounts WHERE account_id = '{account_id}';
        """
        cursor.execute(check_query)
        result = cursor.fetchone()
        print(f"Custos Conta - {account_id}, {account_cost}")
        if result == None:
            # O account_id e tag_name não existem, então vamos inserir uma nova linha
            insert_query = f"""
                INSERT INTO accounts (account_id,unblended_cost)
                VALUES ({account_id}, '{account_cost}');
            """
            cursor.execute(insert_query)
            conn.commit()
        else:
            # account_id e tag_name existem, então vamos atualizar unblended cost
            update_query = f"""
                UPDATE accounts SET unblended_cost = {account_cost}
                WHERE account_id = '{account_id}';
            """
            cursor.execute(update_query)
            conn.commit()

    except (Exception, psycopg2.Error) as error:
        # Fechando a conexão com o banco de dados
        print(f"Erro de banco de dados: {error}")
    finally:
        # Fechando a conexão
        if conn:
            cursor.close()
            conn.close()

def write_cost_by_tag(db_config,account_id,tag_name,type_tag,tag_unblended_cost):
    try:
            # Conectando ao banco de dados
            conn = psycopg2.connect(**db_config)
            cursor = conn.cursor()

            # Comando SQL para inserir os valores na tabela account
            # Verificando se o account_id já existe na tabela
            check_query = f"""
                SELECT FROM tag_cost WHERE account_id = '{account_id}' and tag_name = '{tag_name}';
            """
            cursor.execute(check_query)
            result = cursor.fetchone()
            print(f"Custos - {account_id}, {tag_name}, {tag_unblended_cost}, {type_tag}")
            if result == None:
                # O account_id e tag_name não existem, então vamos inserir uma nova linha
                insert_query = f"""
                    INSERT INTO tag_cost (account_id,tag_name,unblended_cost,type)
                    VALUES ({account_id}, '{tag_name}', '{tag_unblended_cost}','{type_tag}');
                """
                cursor.execute(insert_query)
                conn.commit()
            else:
                # account_id e tag_name existem, então vamos atualizar unblended cost
                update_query = f"""
                    UPDATE tag_cost SET unblended_cost = {tag_unblended_cost}
                    WHERE account_id = '{account_id}' AND tag_name = '{tag_name}';
                """
                cursor.execute(update_query)
                conn.commit()

    except (Exception, psycopg2.Error) as error:
        # Fechando a conexão com o banco de dados
        print(f"Erro de banco de dados: {error}")
    finally:
        # Fechando a conexão
        if conn:
            cursor.close()
            conn.close()



def get_cost_by_tag(session,tag_name):
    # Cria um cliente para o AWS Cost Explorer
    ce_client = session.client('ce')

    # Define o período de tempo para o mês corrente
    now = datetime.now()
    start_date = f"{now.year}-{now.month:02d}-01"
    end_date = f"{now.year}-{now.month:02d}-{now.day:02d}"

    # Define os serviços a serem incluídos na consulta
    services = ["Amazon Elastic Compute Cloud - Compute", "Amazon Elastic Compute Cloud - Other", "Amazon Simple Storage Service", "Amazon Elastic MapReduce"]
    # Prepara o filtro de tags
    tags_filter = {
        'Tags': {
            "Key": "Name",
            'Values': [tag_name]
        }
    }

    response = ce_client.get_cost_and_usage(
        TimePeriod={'Start': start_date, 'End': end_date},
        Granularity='MONTHLY',
        Metrics=["UnblendedCost"],
        Filter={
            "And": [
                {"Dimensions": {"Key": "SERVICE", "Values": services}},
                tags_filter
            ]
        },
        GroupBy=[
            {"Type": "DIMENSION", "Key": "SERVICE"}
        ]
    )
    # print(response[0]['ResultsByTime']['Groups'])
    soma = 0
    for group in response['ResultsByTime'][0]['Groups']:
        soma=soma + float(group['Metrics']['UnblendedCost']['Amount'])
    
    return soma
 
#def list_emr_clusters_by_tag(emr_client,tagging_client,account_id):
def list_emr_clusters_by_tag(session,account_id):

    clusters_emr = []

    # Cria um cliente para o serviço EMR
    
    emr_client = session.client('emr')

    # Cria um cliente para o serviço Resource Groups Tagging API
    tagging_client = session.client('resourcegroupstaggingapi')

    # Lista os clusters EMR
    response = emr_client.list_clusters(ClusterStates=['STARTING', 'BOOTSTRAPPING', 'RUNNING', 'WAITING', 'TERMINATING'])
        
    # Para cada cluster, obter as tags e imprimir a tag "Name"
    for cluster in response['Clusters']:
        cluster_id = cluster['Id']
        tags_response = tagging_client.get_resources(
#            ResourceTypeFilters=['elasticmapreduce:cluster'],
            ResourceARNList=[
                f'arn:aws:elasticmapreduce:{session.region_name}:{account_id}:cluster/{cluster_id}'
            ]
        )
        
        if tags_response['ResourceTagMappingList']:
            tags = tags_response['ResourceTagMappingList'][0]['Tags']
            name_tag = next((tag for tag in tags if tag['Key'] == 'Name'), None)
            if name_tag:
                clusters_emr.append(name_tag['Value'])

                
    return clusters_emr

def write_inventory_items(db_config,permitted_regions,resource_types):
    now = datetime.now()
    try:
        # Conectando ao banco de dados
        conn = psycopg2.connect(**db_config)
        cursor = conn.cursor()
        for region in permitted_regions:
            # Cria uma sessão e um cliente Config para cada região permitida
            regional_session = boto3.Session(profile_name=args.profile, region_name=region)
            config_client = regional_session.client('config')

            for full_resource_type in resource_types:
                # Separa o resource_type em service e resource_type
                parts = full_resource_type.split("::")
                service = parts[1]
                resource_type = parts[2]

                discovered_resources = list_discovered_resources(config_client, full_resource_type)
                for resource_id in discovered_resources:
                    # Comando SQL para inserir os valores
                    insert_query = f"""
                        INSERT INTO resources (account_id, region, service, resource_type, resource_id, date_register)
                        VALUES ('{account_id}', '{region}', '{service}', '{resource_type}', '{resource_id}', '{now}');
                    """
                    # Executando o comando
                    cursor.execute(insert_query)
                    conn.commit()
                    # print("Valores inseridos com sucesso:")
                    print(f"{account_id},{region},{service},{resource_type},{resource_id}")

    except (Exception, psycopg2.Error) as error:
        # Fechando a conexão com o banco de dados
        print(f"Erro de banco de dados: {error}")
    finally:
        # Fechando a conexão
        if conn:
            cursor.close()
            conn.close()



def get_resource_types(db_config):
    resource_types = []
    try:
        # Conectando ao banco de dados
        conn = psycopg2.connect(**db_config)
        cursor = conn.cursor()

       # Consulta para obter os tipos de recursos da tabela "resources_type"
        query = "SELECT types FROM resources_type"
        cursor.execute(query)
        resource_types = [row[0] for row in cursor.fetchall()]

    #     # Lê os tipos de recursos do arquivo especificado
    #     with open(args.resource_file, 'r') as file:
    #         resource_types = [line.strip() for line in file if line.strip()]

    except (Exception, psycopg2.Error) as error:
        print(f"Erro de banco de dados: {error}")

    finally:
        # Fechando a conexão
        if conn:
            cursor.close()
            conn.close()
    return resource_types

def update_account_name(db_config,account_id,account_name):
    try:
            # Conectando ao banco de dados
            conn = psycopg2.connect(**db_config)
            cursor = conn.cursor()

            # Comando SQL para inserir os valores na tabela account
            # Verificando se o account_id já existe na tabela
            check_query = f"""
                SELECT COUNT(*) FROM accounts WHERE account_id = '{account_id}';
            """

            cursor.execute(check_query)
            result = cursor.fetchone()

            if result[0] == 0:
                # O account_id não existe, então vamos inserir uma nova linha
                insert_query = f"""
                    INSERT INTO accounts (account_id, account_name)
                    VALUES ({account_id}, {account});
                """
                cursor.execute(insert_query)
                conn.commit()
                print("Nova linha inserida com sucesso:")
                print(f"account_id: {account_id}, account_name: {account}")
            else:
                print(f"O account_id {account_id} já existe na tabela.")

    except (Exception, psycopg2.Error) as error:
        print(f"Erro de banco de dados: {error}")

    finally:
        # Fechando a conexão
        if conn:
            cursor.close()
            conn.close()
        


def clean_table_records(db_config,account_id):
    try:
            # Conectando ao banco de dados
            conn = psycopg2.connect(**db_config)
            cursor = conn.cursor()

            # Comando SQL para excluir registros com o account_id específico
            delete_query = f"""
                DELETE FROM resources
                WHERE account_id = '{account_id}';
            """

            # Executando o comando
            cursor.execute(delete_query)
            conn.commit()
            print(f"Registros com account_id {account_id} excluídos com sucesso!")

    except (Exception, psycopg2.Error) as error:
        print(f"Erro de banco de dados: {error}")

    finally:
        # Fechando a conexão
        if conn:
            cursor.close()
            conn.close()
        


def list_discovered_resources(config_client, resource_type):
    """
    Lista os recursos descobertos de um tipo específico, usando um cliente de serviço Config fornecido.
    
    :param config_client: Cliente do serviço AWS Config.
    :param resource_type: Tipo de recurso para listar (ex: 'AWS::S3::Bucket', 'AWS::EC2::Instance').
    :return: Lista de IDs de recursos descobertos.
    """
    # Lista para armazenar os recursos descobertos
    discovered = []

    # Chame o método list_discovered_resources do cliente Config
    paginator = config_client.get_paginator('list_discovered_resources')
    for page in paginator.paginate(resourceType=resource_type):
        for resource in page['resourceIdentifiers']:
            discovered.append(resource['resourceId'])

    return discovered

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='List discovered resources in specified AWS regions for a specific AWS CLI profile.')
    parser.add_argument('profile', help='The name of the AWS CLI profile to use')

    args = parser.parse_args()

    # Obtém o número da conta da AWS
    session = boto3.Session(profile_name=args.profile)
#    session = boto3.Session(profile_name='sts_cli')
    sts_client = session.client('sts')
    account_id = sts_client.get_caller_identity()['Account']
    account = '{{account}}' # nome conhecido da conta pelo time Nike
    account = '{{account}}' # nome conhecido da conta pelo time Nike
    # account_name = '{{account_name}}'  # nome de registro da conta na AWS ex.: eec-aws-br-ds-dataservices-dev

    # Define as regiões permitidas
    permitted_regions = ['sa-east-1', 'us-east-1']
#    permitted_regions = ['sa-east-1']

    # Configurações do banco de dados
    db_config = {
        'host': '{{pgs_host}}',
        'user': '{{pgs_login}}',
        'password': '{{pgs_pw}}',
        'dbname': 'inventario'
    }

    # Limpar registros do inventário anterior
    clean_table_records(db_config,account_id)

    # Atualizando o account name na tabela accounts
    update_account_name(db_config,account_id,account)

    # Consulta para obter os tipos de recursos da tabela "resources_type"
    resource_types = get_resource_types(db_config)
    
    # Escreve os itens de inventário 
    write_inventory_items(db_config,permitted_regions,resource_types)

    # Lista as tags Name dos clusters EMRs
    print('print-session antes da func',session)
     

    tags_names = list_emr_clusters_by_tag(session,account_id)

    # Obtem custo no Cost Explorer por tag Name
    old_tag_name = ""
    type_tag="EMR Cluster"
    for tag_name in tags_names:
        if (old_tag_name != tag_name):
            tag_unblended_cost = get_cost_by_tag(session,tag_name)
            write_cost_by_tag(db_config,account_id,tag_name,type_tag,tag_unblended_cost)

        old_tag_name = tag_name

    # Obetem custo total da conta da AWS
    write_cost_by_account(db_config,session,account_id)

    # Obtem custo dos servicos
    write_cost_by_services(db_config,session,account_id)
    # write_cost_by_buckets(db_config,session,account_id)
