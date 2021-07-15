package com.bcldb.util;


import org.apache.commons.lang3.exception.ExceptionUtils;

import com.bcldb.exception.BusinessRuleException;
import com.bcldb.exception.ValidationException;
import com.bcldb.services.common.type.ServiceErrorType;
import com.bcldb.services.common.type.SeverityType;

import wmsservice.ErrorMessage;

public final class ErrorHandler {
    // common runtime errors
    public static final int ERROR_CODE_1 = 1000;
    // request paraemters validation
    public static final int ERROR_CODE_2 = 2000;
    // business error
    public static final int ERROR_CODE_3 = 3000;
    

    public ErrorHandler() {
        super();
    }

	public void reportError(Exception be, String message) throws ErrorMessage {
		ServiceErrorType error = new ServiceErrorType();
		error.setTimestamp(CommonHelper.getTimestamp());
		if(be instanceof ValidationException){			
			error.setErrorCode(ERROR_CODE_2);	
			error.setSeverity(SeverityType.WARN);
			error.setErrorMessage(ExceptionUtils.getRootCauseMessage(be));
		}
		if(be instanceof BusinessRuleException){			
			error.setErrorCode(ERROR_CODE_3);	
			error.setSeverity(SeverityType.WARN);
			error.setErrorMessage("Business Rule error :" + ExceptionUtils.getRootCauseMessage(be));
		}else{
			error.setErrorCode(ERROR_CODE_1);
			error.setSeverity(SeverityType.MAJOR);
			error.setErrorMessage("Service operation error :" + ExceptionUtils.getRootCauseMessage(be));
		}
		throw new ErrorMessage(message, error);
		
	}
}
