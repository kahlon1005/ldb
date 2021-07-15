package com.bcldb.ejb;

import static org.junit.Assert.assertTrue;

import org.junit.Before;
import org.junit.Rule;
import org.junit.Test;
import org.mockito.Mock;
import org.mockito.junit.MockitoJUnit;
import org.mockito.junit.MockitoRule;


public class WmsServiceBeanTest {


	@Mock
	WmsServiceBean bean;
	
	@Rule public MockitoRule mockitoRule = MockitoJUnit.rule();
	
	
	@Before
	public void setup(){
		
	}
	
	@Test
	public void getStuckShipmentsTest(){
		assertTrue(true);
		
	}
	
}
