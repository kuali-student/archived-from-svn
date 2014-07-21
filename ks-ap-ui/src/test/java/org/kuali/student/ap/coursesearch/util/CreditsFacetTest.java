package org.kuali.student.ap.coursesearch.util;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

import java.math.BigDecimal;
import java.util.List;

import org.junit.Test;
import org.kuali.student.ap.coursesearch.CourseSearchItem;
import org.kuali.student.ap.coursesearch.dataobject.CourseSearchItemImpl;
import org.kuali.student.ap.coursesearch.dataobject.FacetItem;


public class CreditsFacetTest {
    @Test
    public void testGetFacetItems() throws Exception {
        CreditsFacet facet = new CreditsFacet();

        CourseSearchItemImpl multiple = new CourseSearchItemImpl();
        multiple.setCreditMin(new BigDecimal(1));
        multiple.setCreditMax(new BigDecimal(3));
        multiple.setMultipleCredits(new BigDecimal[] {new BigDecimal(1),new BigDecimal(3)});
        multiple.setCreditType(CourseSearchItem.CreditType.Multiple);
        facet.process(multiple);

        CourseSearchItemImpl range = new CourseSearchItemImpl();
        range.setCreditMin(new BigDecimal(4));
        range.setCreditMax(new BigDecimal(6));
        range.setCreditType(CourseSearchItem.CreditType.Range);
        facet.process(range);

        CourseSearchItemImpl fixed = new CourseSearchItemImpl();
        fixed.setCreditMin(new BigDecimal(7));
        fixed.setCreditMax(new BigDecimal(7));
        fixed.setCreditType(CourseSearchItem.CreditType.Fixed);
        facet.process(fixed);

        List<FacetItem> list = facet.getFacetItems();

        assertEquals(6, list.size());
        assertEquals("5", list.get( 3 ).getDisplayName());
        assertEquals("5.0", list.get( 3 ).getKey());
    }

    @Test
    public void testProcessCreditsTypeMultiple() throws Exception {
        CourseSearchItemImpl course = new CourseSearchItemImpl();
//        course.setCreditMin(1);
//        course.setCreditMax(3);
        course.setCredit("1, 3");
        course.setMultipleCredits(new BigDecimal[]{new BigDecimal(1), new BigDecimal(3)});
        course.setCreditType(CourseSearchItem.CreditType.Multiple);

        CreditsFacet facet = new CreditsFacet();
        facet.process(course);
        assertTrue(course.getCreditsFacetKeys().contains("1.0"));
        assertTrue(course.getCreditsFacetKeys().contains("3.0"));
        assertTrue(course.getCreditsFacetKeys().size() == 2);
    }

    @Test
    public void testProcessCreditsTypeMultiple2() throws Exception {
        CourseSearchItemImpl course = new CourseSearchItemImpl();
//        course.setCreditMin(1);
//        course.setCreditMax(3);
        course.setCredit("1, 3, 3.5");
        course.setMultipleCredits(new BigDecimal[]{new BigDecimal(1), new BigDecimal(3), new BigDecimal("3.5")});
        course.setCreditType(CourseSearchItem.CreditType.Multiple);

        CreditsFacet facet = new CreditsFacet();
        facet.process(course);
        assertTrue(course.getCreditsFacetKeys().contains("1.0"));
        assertTrue(course.getCreditsFacetKeys().contains("3.0"));
        assertTrue(course.getCreditsFacetKeys().contains("3.5"));
        assertTrue(course.getCreditsFacetKeys().size() == 3);
    }

    @Test
    public void testProcessCreditsTypeMultipleAboveMax() throws Exception {
        CourseSearchItemImpl course = new CourseSearchItemImpl();
//        course.setCreditMin(1);
//        course.setCreditMax(3);
        course.setCredit("1, 3, 3.5, 5.5, 6, 7, 7.5");
        course.setMultipleCredits(new BigDecimal[]{new BigDecimal(1), new BigDecimal(3), new BigDecimal("3.5"), new BigDecimal("5.5"), new BigDecimal(6), new BigDecimal(7), new BigDecimal("7.5")});
        course.setCreditType(CourseSearchItem.CreditType.Multiple);

        CreditsFacet facet = new CreditsFacet();
        facet.process(course);
        assertTrue(course.getCreditsFacetKeys().contains("1.0"));
        assertTrue(course.getCreditsFacetKeys().contains("3.0"));
        assertTrue(course.getCreditsFacetKeys().contains("3.5"));
        assertTrue(course.getCreditsFacetKeys().contains("5.5"));
        assertTrue(!course.getCreditsFacetKeys().contains("6.0"));
        assertTrue(course.getCreditsFacetKeys().contains("6+"));
        assertEquals(5, course.getCreditsFacetKeys().size());
    }

    @Test
    public void testProcessCreditsTypeRange() throws Exception {
        CourseSearchItemImpl course = new CourseSearchItemImpl();
        course.setCreditMin(new BigDecimal(1));
        course.setCreditMax(new BigDecimal(3));
        course.setCreditType(CourseSearchItem.CreditType.Range);

        CreditsFacet facet = new CreditsFacet();
        facet.process(course);
        assertTrue(course.getCreditsFacetKeys().contains("1.0"));
        assertTrue(course.getCreditsFacetKeys().contains("2.0"));
        assertTrue(course.getCreditsFacetKeys().contains("3.0"));
        assertTrue(course.getCreditsFacetKeys().size() == 3);
    }

    @Test
    public void testProcessCreditsTypeRangeAboveMax() throws Exception {
        CourseSearchItemImpl course = new CourseSearchItemImpl();
        course.setCreditMin(new BigDecimal(4));
        course.setCreditMax(new BigDecimal(7));
        course.setCreditType(CourseSearchItem.CreditType.Range);

        CreditsFacet facet = new CreditsFacet();
        facet.process(course);
        assertTrue(course.getCreditsFacetKeys().contains("4.0"));
        assertTrue(course.getCreditsFacetKeys().contains("5.0"));
        assertTrue(course.getCreditsFacetKeys().contains("6+"));
        assertEquals(3, course.getCreditsFacetKeys().size());
    }

    @Test
    public void testProcessCreditsTypeFixed() throws Exception {
        CourseSearchItemImpl course = new CourseSearchItemImpl();
        course.setCreditMin(new BigDecimal(1));
        course.setCreditMax(new BigDecimal(1));
        course.setCreditType(CourseSearchItem.CreditType.Fixed);

        CreditsFacet facet = new CreditsFacet();
        facet.process(course);
        assertEquals("1.0", course.getCreditsFacetKey());
    }

    @Test
    public void testProcessCreditsTypeFixedAboveMax() throws Exception {
        CourseSearchItemImpl course = new CourseSearchItemImpl();
        course.setCreditMin(new BigDecimal(9));
        course.setCreditMax(new BigDecimal(9));
        course.setCreditType(CourseSearchItem.CreditType.Fixed);

        CreditsFacet facet = new CreditsFacet();
        facet.process(course);
        assertEquals("6+", course.getCreditsFacetKey());
    }
}
