NOTE: This is the "Founders Release" of Kuali Student Curriculum Management 2.0
The founders release is replaced by the version located here - https://svn.kuali.org/repos/student/enrollment/aggregate/tags/student-2.0.0-cm




The aggregate project uses svn:externals to map other KS modules into this module
when checking out the source tree.

The svn.externals file controls what local directories appear in the checkout, and what
actual location inside Subversion they represent.

Even though this directory appears to be blank when browsing it over http, Subversion clients
will detect the svn:externals definitions and checkout the mapped locations when checking out
the top level project.
