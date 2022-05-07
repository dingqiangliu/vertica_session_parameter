/* Copyright (c) DingQiang Liu(dingqiangliu@gmail.com), 2012 - 2022 -*- C++ -*- */
/*
 * Description: User Defined Scalar Functions for setting user defined session parameters
 *
 * Create Date: May 7, 2022
 */

#include "Vertica.h"
#include <sstream>
#include <map>

using namespace Vertica;
using namespace std;


class SetSessionParameter : public ScalarFunction
{
public:
    void processBlock(ServerInterface &srvInterface,
                      BlockReader &argReader,
                      BlockWriter &resWriter) override
    {
        VString vName  = argReader.getStringRef(0);
        VString vValue = argReader.getStringRef(1);

        if( ! vName.isNull() )
            name = vName.str();

        if( ! name.empty() ) 
        {
            isNull = vValue.isNull();
            if( ! isNull )
            {
                value = vValue.str();
                isNull = false;
            }

            resWriter.getStringRef().copy(name);
        }
        else
        {
            resWriter.getStringRef().setNull();
        }

        resWriter.next();
    }

    using ScalarFunction::destroy;
    void destroy(ServerInterface &srvInterface, const SizedColumnTypes &argTypes, SessionParamWriterMap &udParams) override
    {
        // set the name/value on session parameter
        if( ! name.empty() ) 
        {
            if( !isNull )
            {
                udParams.getUDSessionParamWriter("library").getStringRef(name).copy(value);
            }
            else
            {
                // Notice: "getStringRef(name).setNull()" can not really store NULL value.
                udParams.getUDSessionParamWriter("library").clearParameter(name);
            }
        }
    }

private:
    string name;
    string value;
    bool isNull;
};


class SetSessionParameterFactory : public ScalarFunctionFactory
{
    ScalarFunction *createScalarFunction(ServerInterface &interface) override
    {
        return vt_createFuncObject<SetSessionParameter>(interface.allocator);
    }

    void getPrototype(ServerInterface &interface,
                              ColumnTypes &argTypes,
                              ColumnTypes &returnType) override
    {
        // Takes two varchars as inputs: name and value
        argTypes.addVarchar();
        argTypes.addVarchar();

        returnType.addVarchar();
    }

    void getReturnType(ServerInterface &srvInterface,
                       const SizedColumnTypes &argTypes,
                       SizedColumnTypes &returnType) override
    {
        returnType.addVarchar(256);
    }

public:
    SetSessionParameterFactory() 
    {
        vol = STABLE;
        strict = CALLED_ON_NULL_INPUT;
    }

};


RegisterFactory(SetSessionParameterFactory);

