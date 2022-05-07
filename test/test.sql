/*****************************
 *
 * User Defined Scalar Functions for user defined session parameters
 *
 * Copyright DingQiang Liu(dingqiangliu@gmail.com), 2012 - 2022
 */

-- unit tests
select error_on_check_false(
        SetSessionParameter(null, null) is null
        , 'set NULL parameter name should return NULLL', 'Case: set NULL parameter name with NULL value', ''
    ) as "Case: set NULL parameter name with NULL value";

select error_on_check_false(
        SetSessionParameter(null, '') is null
        , 'set NULL parameter name should return NULLL', 'Case: set NULL parameter name with empty value', ''
    ) as "Case: set NULL parameter name with empty value";

select error_on_check_false(
        SetSessionParameter(null, 'Non empty value') is null
        , 'set NULL parameter name should return NULLL', 'Case: set NULL parameter name with non-empty value', ''
    ) as "Case: set NULL parameter name with non-empty value";

select error_on_check_false(
        SetSessionParameter('', null) is null
        , 'set empty parameter name should return NULLL', 'Case: set empty parameter name with NULL value', ''
    ) as "Case: set empty parameter name with NULL value";

select error_on_check_false(
        SetSessionParameter('', '') is null
        , 'set empty parameter name should return NULLL', 'Case: set empty parameter name with empty value', ''
    ) as "Case: set empty parameter name with NULL value";

select error_on_check_false(
        SetSessionParameter('', 'Non-empty value') is null
        , 'set empty parameter name should return NULLL', 'Case: set empty parameter name with non-empty value', ''
    ) as "Case: set empty parameter name with non-empty value";

select error_on_check_false(
        GetSessionParameter(null) is null
        , 'get NULL parameter name should return NULLL', 'Case: get NULL parameter name', ''
    ) as "Case: get NULL parameter name";

select error_on_check_false(
        GetSessionParameter('') is null
        , 'get empty parameter name should return NULLL', 'Case: get empty parameter name', ''
    ) as "Case: get empty parameter name";

select error_on_check_false(
        GetSessionParameter('nonexistent') is null
        , 'get nonexistent parameter name should return NULLL', 'Case: get nonexistent parameter name', ''
    ) as "Case: get nonexistent parameter name";

select error_on_check_false(
        SetSessionParameter('case_null_parameter_value', null) = 'case_null_parameter_value'
        , 'set NULL parameter value should return paramter name', 'Case: set NULL parameter value', ''
    ) as "Case: set NULL parameter value";
select error_on_check_false(
        GetSessionParameter('case_null_parameter_value') is null
        , 'get NULL parameter value should return NULL', 'Case: get NULL parameter value', ''
    ) as "Case: get NULL parameter value";

select SetSessionParameter('case_empty_parameter_value', '');
select error_on_check_false(
        GetSessionParameter('case_empty_parameter_value') = ''
        , 'get empty parameter value should return empty', 'Case: get empty parameter value', ''
    ) as "Case: get empty parameter value";

select SetSessionParameter('case_non_empty_parameter_value', 'non-empty parameter value');
select error_on_check_false(
        GetSessionParameter('case_non_empty_parameter_value') = 'non-empty parameter value'
        , 'get non-empty parameter value should return same', 'Case: get non-empty parameter value', ''
    ) as "Case: get non-empty parameter value";


select SetSessionParameter('case_non_empty_parameter_value_after_NULL_set', 'non-empty parameter value');

show session udparameter all;

select SetSessionParameter('case_non_empty_parameter_value_after_NULL_set', null);
select error_on_check_false(
        GetSessionParameter('case_non_empty_parameter_value_after_NULL_set') is null 
        , 'get non-empty parameter value after NULL set should return NULL', 'Case: get non-empty parameter value after NULL set', ''
    ) as "Case: get non-empty parameter value after NULL set";

show session udparameter all;


-- set/get user defined parameter
select
    SetSessionParameter('client_os', client_os)
    , SetSessionParameter('client_os_user_name', client_os_user_name)
from current_session;

-- get user defined parameter in multiple rows dataset 
select extract(epoch from ts)::int as id
    , GetSessionParameter('client_os') as client_os
    , GetSessionParameter('client_os_user_name') as client_os_user_name
from (
    select '1970-01-01 00:00:01 +0'::timestamp as tm
    union
    select '1970-01-01 00:00:04 +0'::timestamp as tm
 ) t0 
timeseries ts as '1 second' over (order by tm);

