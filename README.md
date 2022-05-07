# User Defined Session Parameters

Vertica User Defined Scalar Functions (UDSF) to set and get user defined session parameters

## Usages

1. **SetSessionParameter** (name , value)

   ***Parameters:***
   
   * name: string. Name of parameter.
   * value: string. Value of parameter.
   
   ***Return:*** string, name of parameter. Return NULL if parameter name is NULL, empty.


2. **GetSessionParameter** (name)

   ***Parameters:***

   * name: string. Name of parameter.
   
   ***Return:*** string, value of parameter. Return NULL if parameter name is NULL, empty or nonexistent.

## Examples

- set/get user defined parameter:
  
  ```SQL
  select SetSessionParameter('case_null_parameter_value', null);
      SetSessionParameter     
  ----------------------------
   case_null_parameter_value
  (1 row)
  
  select GetSessionParameter('case_null_parameter_value') is null as "Case: get NULL parameter value";
   Case: get NULL parameter value 
  ---------------------------------
   t
  (1 row)
  
  select SetSessionParameter('case_empty_parameter_value', '');
      SetSessionParameter     
  ----------------------------
   case_empty_parameter_value
  (1 row)
  
  select GetSessionParameter('case_empty_parameter_value') = '' as "Case: get empty parameter value";
   Case: get empty parameter value 
  ---------------------------------
   t
  (1 row)
  
  select SetSessionParameter('case_non_empty_parameter_value', 'non-empty parameter value');
        SetSessionParameter       
  --------------------------------
   case_non_empty_parameter_value
  (1 row)
  
  select GetSessionParameter('case_non_empty_parameter_value') = 'non-empty parameter value' as "Case: get non-empty parameter value";
   Case: get non-empty parameter value 
  -------------------------------------
   t
  (1 row)
  
  show session udparameter all;
   schema |     library      |              key               |           value           
  --------+------------------+--------------------------------+---------------------------
   public | sessionparameter | case_empty_parameter_value     | 
   public | sessionparameter | case_non_empty_parameter_value | non-empty parameter value
  (2 rows)
  
  select
      SetSessionParameter('client_os', client_os)
      , SetSessionParameter('client_os_user_name', client_os_user_name)
  from current_session;
   SetSessionParameter | SetSessionParameter 
  ---------------------+---------------------
   client_os           | client_os_user_name
  (1 row)
  
  select extract(epoch from ts)::int as id
      , GetSessionParameter('client_os') as client_os
      , GetSessionParameter('client_os_user_name') as client_os_user_name
  from (
      select '1970-01-01 00:00:01 +0'::timestamp as tm
      union
      select '1970-01-01 00:00:04 +0'::timestamp as tm
   ) t0 
  timeseries ts as '1 second' over (order by tm);
   id |           client_os            | client_os_user_name 
  ----+--------------------------------+---------------------
    1 | Linux 5.13.0-40-generic x86_64 | dbadmin
    2 | Linux 5.13.0-40-generic x86_64 | dbadmin
    3 | Linux 5.13.0-40-generic x86_64 | dbadmin
    4 | Linux 5.13.0-40-generic x86_64 | dbadmin
  (4 rows)
  ```


## Install, test and uninstall

Before build and install, g++ should be available(**yum -y groupinstall "Development tools" && yum -y groupinstall "Additional Development"** can help on this).

 * Build: 

   ```bash
   autoreconf -f -i && ./configure && make
   ```

 * Install: 

   ```bash
   make install
   ```

 * Test: 

   ```bash
   make test
   ```

 * Uninstall: 

   ```bash
   make uninstall
   ```

 * Clean: 

   ```bash
   # make distclean
   make clean
   ```

 * Clean all: 

   ```bash
   git clean -f .
   ```
