package org.kuali.student.ap.academicplan.dto;

import org.junit.Test;
import org.junit.Assert;

public class PlaceholderInfoTest {

	@Test
	public void testSanity() {
		PlaceholderInfo pl = new PlaceholderInfo();
		pl.setParm1("foo");
		pl.setNotes("bar");
		Assert.assertEquals("foo", pl.getParm1());
		Assert.assertEquals("bar", pl.getNotes());
	}

}
