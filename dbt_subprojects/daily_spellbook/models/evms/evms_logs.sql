{{ config(
        schema='evms',
        alias = 'logs',
        unique_key=['blockchain', 'tx_hash'],
        post_hook='{{ expose_spells(\'["ethereum", "polygon", "bnb", "avalanche_c", "gnosis", "fantom", "optimism", "arbitrum", "celo", "base", "zksync", "zora", "scroll", "linea", "zkevm", "blast", "mantle", "ronin"]\',
                                    "sector",
                                    "evms",
                                    \'["hildobby","rantum"]\') }}'
        )
}}

{% set logs_models = [
     ('ethereum', source('ethereum', 'logs'))
     , ('polygon', source('polygon', 'logs'))
     , ('bnb', source('bnb', 'logs'))
     , ('avalanche_c', source('avalanche_c', 'logs'))
     , ('gnosis', source('gnosis', 'logs'))
     , ('fantom', source('fantom', 'logs'))
     , ('optimism', source('optimism', 'logs'))
     , ('arbitrum', source('arbitrum', 'logs'))
     , ('celo', source('celo', 'logs'))
     , ('base', source('base', 'logs'))
     , ('zksync', source('zksync', 'logs'))
     , ('zora', source('zora', 'logs'))
     , ('scroll', source('scroll', 'logs'))
     , ('linea', source('linea', 'logs'))
     , ('zkevm', source('zkevm', 'logs'))
     , ('blast', source('blast', 'logs'))
     , ('mantle', source('mantle', 'logs'))
     , ('mode', source('mode', 'logs'))
     , ('sei', source('sei', 'logs'))
     , ('ronin', source('ronin', 'logs'))
] %}

SELECT *
FROM (
        {% for logs_model in logs_models %}
        SELECT
        '{{ logs_model[0] }}' AS blockchain
        , block_time
        , block_number
        , block_hash
        , contract_address
        , topic0
        , topic1
        , topic2
        , topic3
        , data
        , tx_hash
        , index
        , tx_index
        , block_date
        , tx_from
        , tx_to
        FROM {{ logs_model[1] }}
        {% if not loop.last %}
        UNION ALL
        {% endif %}
        {% endfor %}
        );