/* Copyright (c) DingQiang Liu(dingqiangliu@gmail.com), 2012 - 2022 -*- C++ -*- */
/*
 * Description: User Defined Scalar Functions for getting user defined session parameters
 * 
 * Create Date: May 7, 2022
 */
#include "Vertica.h"
#include <sstream>

using namespace Vertica;
using namespace std;


class GetSessionParameter : public ScalarFunction
{
public:
    void processBlock(ServerInterface &srvInterface,
                      BlockReader &argReader,
                      BlockWriter &resWriter) override
    {
        do 
        {
            VString vName = argReader.getStringRef(0);
            if( ! vName.isNull() ) 
            {
                string name = vName.str();
                ParamReader paramReader = srvInterface.getUDSessionParamReader("library");
                if(paramReader.containsParameter(name))
                {
                    VString value = paramReader.getStringRef(name);
                    if( ! value.isNull() ) 
                        resWriter.getStringRef().copy(value);
                    else 
                        resWriter.getStringRef().setNull();
                }
                else 
                {
                    resWriter.getStringRef().setNull();
                }
            }
            else 
            {
              resWriter.getStringRef().setNull();
            }
           	
            resWriter.next();
        } while (argReader.next());
    }
};


class GetSessionParameterFactory : public ScalarFunctionFactory
{
    ScalarFunction *createScalarFunction(ServerInterface &interface) override
    {
        return vt_createFuncObject<GetSessionParameter>(interface.allocator);
    }

    void getPrototype(ServerInterface &interface,
                      ColumnTypes &argTypes,
                      ColumnTypes &returnType) override
    {
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
    GetSessionParameterFactory() 
    {
        vol = STABLE;
        strict = STRICT;
    }
};


RegisterFactory(GetSessionParameterFactory);

