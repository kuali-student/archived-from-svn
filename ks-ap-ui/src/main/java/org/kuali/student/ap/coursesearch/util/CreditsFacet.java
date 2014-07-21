package org.kuali.student.ap.coursesearch.util;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.kuali.student.ap.coursesearch.CourseSearchItem;
import org.kuali.student.ap.coursesearch.CourseSearchItem.CreditType;
import org.kuali.student.ap.coursesearch.dataobject.CourseSearchItemImpl;
import org.kuali.student.ap.coursesearch.dataobject.FacetItem;

/**
 * Logic for building list of FacetItems and coding CourseSearchItems.
 */
public class CreditsFacet extends AbstractFacet {

    /**
     * DISPLAY_MAX will be the cutoff for when we switch to 6+
     */
	private static final BigDecimal DISPLAY_MAX = new BigDecimal(6);

	private HashSet<BigDecimal> creditFacetSet = new HashSet<BigDecimal>();

	public CreditsFacet() {
		super();
	}

	/**
	 * Overriding because the credits facet list needs to be in numeric order
	 * rather than string order.
	 * 
	 * @return A list of FacetItems.
	 */
	@Override
	public List<FacetItem> getFacetItems() {
		Float[] list = creditFacetSet.toArray(new Float[0]);
		Arrays.sort(list);

		for (Float credit : list) {
			String display = credit.toString();
			facetItems.add(new FacetItem(display, display.replace(".0", "")));
		}

		return facetItems;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	public void process(CourseSearchItem course) {
		BigDecimal min = course.getCreditMin();
		BigDecimal max = course.getCreditMax();

		List<BigDecimal> list = new ArrayList<BigDecimal>();
		switch (course.getCreditType()) {
		case Range:
			BigDecimal one = new BigDecimal(1);
			for (BigDecimal x = min; x.compareTo(max) <= 0; x = x.add(one)) {
				list.add(x);
			}
			break;
		case Fixed:
			list.add(min);
			break;
		case Multiple:
            if (course.getMultipleCredits() != null) {
                for (BigDecimal credit : course.getMultipleCredits()) {
                    list.add(credit);
                }
            }
            else {
                list.add(min);
            }
			break;
		case Unknown:
		default:
            list.add(min);
			break;

		}

		creditFacetSet.addAll(list);

		Set<String> facetKeys = new java.util.LinkedHashSet<String>();
		for (BigDecimal credit : list) {
		    if (credit.compareTo(DISPLAY_MAX) < 0)
			    facetKeys.add(credit.toString());
            else
                facetKeys.add(DISPLAY_MAX + "+");
        }
		if (CreditType.Range.equals(course.getCreditType())
				&& max.compareTo(DISPLAY_MAX) >= 0)
			facetKeys.add(DISPLAY_MAX + "+");
		((CourseSearchItemImpl) course).setCreditsFacetKeys(facetKeys);
	}
}
