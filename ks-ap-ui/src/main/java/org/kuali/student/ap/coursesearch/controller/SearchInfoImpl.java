package org.kuali.student.ap.coursesearch.controller;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

import org.kuali.rice.core.api.util.KeyValue;
import org.kuali.student.ap.coursesearch.CourseSearchItem;
import org.kuali.student.ap.coursesearch.SearchInfo;

/**
 * Simple object representing pre-processed search data.
 *
 * @see SessionSearchInfo
 * @see org.kuali.student.ap.coursesearch.CourseSearchItem#getSearchColumns()
 * @see org.kuali.student.ap.coursesearch.CourseSearchItem#getFacetColumns()
 */
public class SearchInfoImpl implements Serializable, SearchInfo {
    private static final long serialVersionUID = 8697147011424347285L;

    private final CourseSearchItem item;
    private final String[] sortColumns;
    private final Map<String, List<KeyValue>> facetColumns;

    public SearchInfoImpl(CourseSearchItem item) {
        this.item = item;
        sortColumns = item.getSortColumns();
        facetColumns = new java.util.LinkedHashMap<String, List<KeyValue>>();
        for (Map.Entry<String, Map<String, Map<String, KeyValue>>> fe : item
                .getFacetColumns().entrySet()) {
            List<KeyValue> fl = facetColumns.get(fe.getKey());
            if (fl == null)
                facetColumns.put(fe.getKey(), fl = new ArrayList<KeyValue>());
            for (Map<String, KeyValue> fv : fe.getValue().values())
                fl.addAll(fv.values());
        }

    }

    @Override
    public String toString() {
        return "SearchInfoImpl [searchColumns=" + item.getCourseId()
                + ", sortColumns=" + Arrays.toString(sortColumns)
                + ", facetColumns=" + facetColumns + "]";
    }

    @Override
    public CourseSearchItem getItem() {
        return item;
    }

    @Override
    public String[] getSortColumns() {
        return sortColumns;
    }

    @Override
    public Map<String, List<KeyValue>> getFacetColumns() {
        return facetColumns;
    }
}
