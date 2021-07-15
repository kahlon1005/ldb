package com.bcldb.exception;

import javax.ejb.EJBException;

public class ValidationException extends EJBException {

	private static final long serialVersionUID = 2548555029948415503L;
	
	public ValidationException(String string) {
	    super(string);
	}

}
