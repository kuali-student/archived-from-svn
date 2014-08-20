#!/bin/sh

java -jar $WORKSPACE/apache-jmeter-2.11/lib/ext/CMDRunner.jar --tool Reporter --generate-png $WORKSPACE/reports/getActivityOffering.png --input-jtl $WORKSPACE/reports/svc_course_offering.jtl --plugin-type TimesVsThreads --width 800 --height 600 --include-labels getActivityOffering

java -jar $WORKSPACE/apache-jmeter-2.11/lib/ext/CMDRunner.jar --tool Reporter --generate-png $WORKSPACE/reports/getActivityOfferingCluster.png --input-jtl $WORKSPACE/reports/svc_course_offering.jtl --plugin-type TimesVsThreads --width 800 --height 600 --include-labels getActivityOfferingCluster

java -jar $WORKSPACE/apache-jmeter-2.11/lib/ext/CMDRunner.jar --tool Reporter --generate-png $WORKSPACE/reports/getActivityOfferingClustersByFormatOffering.png --input-jtl $WORKSPACE/reports/svc_course_offering.jtl --plugin-type TimesVsThreads --width 800 --height 600 --include-labels getActivityOfferingClustersByFormatOffering

java -jar $WORKSPACE/apache-jmeter-2.11/lib/ext/CMDRunner.jar --tool Reporter --generate-png $WORKSPACE/reports/getActivityOfferingClustersByIds.png --input-jtl $WORKSPACE/reports/svc_course_offering.jtl --plugin-type TimesVsThreads --width 800 --height 600 --include-labels getActivityOfferingClustersByIds

java -jar $WORKSPACE/apache-jmeter-2.11/lib/ext/CMDRunner.jar --tool Reporter --generate-png $WORKSPACE/reports/getActivityOfferingClustersIdsByFormatOffering.png --input-jtl $WORKSPACE/reports/svc_course_offering.jtl --plugin-type TimesVsThreads --width 800 --height 600 --include-labels getActivityOfferingClustersIdsByFormatOffering

java -jar $WORKSPACE/apache-jmeter-2.11/lib/ext/CMDRunner.jar --tool Reporter --generate-png $WORKSPACE/reports/getActivityOfferingsByCluster.png --input-jtl $WORKSPACE/reports/svc_course_offering.jtl --plugin-type TimesVsThreads --width 800 --height 600 --include-labels getActivityOfferingsByCluster

java -jar $WORKSPACE/apache-jmeter-2.11/lib/ext/CMDRunner.jar --tool Reporter --generate-png $WORKSPACE/reports/getActivityOfferingsByCourseOffering.png --input-jtl $WORKSPACE/reports/svc_course_offering.jtl --plugin-type TimesVsThreads --width 800 --height 600 --include-labels getActivityOfferingsByCourseOffering

java -jar $WORKSPACE/apache-jmeter-2.11/lib/ext/CMDRunner.jar --tool Reporter --generate-png $WORKSPACE/reports/getActivityOfferingsByFormatOffering.png --input-jtl $WORKSPACE/reports/svc_course_offering.jtl --plugin-type TimesVsThreads --width 800 --height 600 --include-labels getActivityOfferingsByFormatOffering

java -jar $WORKSPACE/apache-jmeter-2.11/lib/ext/CMDRunner.jar --tool Reporter --generate-png $WORKSPACE/reports/ggetActivityOfferingsByIds.png --input-jtl $WORKSPACE/reports/svc_course_offering.jtl --plugin-type TimesVsThreads --width 800 --height 600 --include-labels ggetActivityOfferingsByIds

java -jar $WORKSPACE/apache-jmeter-2.11/lib/ext/CMDRunner.jar --tool Reporter --generate-png $WORKSPACE/reports/getActivityOfferingsForSeatPoolDefinition.png --input-jtl $WORKSPACE/reports/svc_course_offering.jtl --plugin-type TimesVsThreads --width 800 --height 600 --include-labels getActivityOfferingsForSeatPoolDefinition

java -jar $WORKSPACE/apache-jmeter-2.11/lib/ext/CMDRunner.jar --tool Reporter --generate-png $WORKSPACE/reports/getActivityOfferingType.png --input-jtl $WORKSPACE/reports/svc_course_offering.jtl --plugin-type TimesVsThreads --width 800 --height 600 --include-labels getActivityOfferingType

java -jar $WORKSPACE/apache-jmeter-2.11/lib/ext/CMDRunner.jar --tool Reporter --generate-png $WORKSPACE/reports/getActivityOfferingTypes.png --input-jtl $WORKSPACE/reports/svc_course_offering.jtl --plugin-type TimesVsThreads --width 800 --height 600 --include-labels getActivityOfferingTypes

java -jar $WORKSPACE/apache-jmeter-2.11/lib/ext/CMDRunner.jar --tool Reporter --generate-png $WORKSPACE/reports/getCourseOffering.png --input-jtl $WORKSPACE/reports/svc_course_offering.jtl --plugin-type TimesVsThreads --width 800 --height 600 --include-labels getCourseOffering

java -jar $WORKSPACE/apache-jmeter-2.11/lib/ext/CMDRunner.jar --tool Reporter --generate-png $WORKSPACE/reports/getCourseOfferingDisplay.png --input-jtl $WORKSPACE/reports/svc_course_offering.jtl --plugin-type TimesVsThreads --width 800 --height 600 --include-labels getCourseOfferingDisplay

java -jar $WORKSPACE/apache-jmeter-2.11/lib/ext/CMDRunner.jar --tool Reporter --generate-png $WORKSPACE/reports/getCourseOfferingDisplaysByIds.png --input-jtl $WORKSPACE/reports/svc_course_offering.jtl --plugin-type TimesVsThreads --width 800 --height 600 --include-labels getCourseOfferingDisplaysByIds

java -jar $WORKSPACE/apache-jmeter-2.11/lib/ext/CMDRunner.jar --tool Reporter --generate-png $WORKSPACE/reports/getCourseOfferingIdsByTerm.png --input-jtl $WORKSPACE/reports/svc_course_offering.jtl --plugin-type TimesVsThreads --width 800 --height 600 --include-labels getCourseOfferingIdsByTerm

java -jar $WORKSPACE/apache-jmeter-2.11/lib/ext/CMDRunner.jar --tool Reporter --generate-png $WORKSPACE/reports/getCourseOfferingIdsByTermAndSubjectArea.png --input-jtl $WORKSPACE/reports/svc_course_offering.jtl --plugin-type TimesVsThreads --width 800 --height 600 --include-labels getCourseOfferingIdsByTermAndSubjectArea

java -jar $WORKSPACE/apache-jmeter-2.11/lib/ext/CMDRunner.jar --tool Reporter --generate-png $WORKSPACE/reports/getCourseOfferingIdsByTermAndUnitsContentOwner.png --input-jtl $WORKSPACE/reports/svc_course_offering.jtl --plugin-type TimesVsThreads --width 800 --height 600 --include-labels getCourseOfferingIdsByTermAndUnitsContentOwner

java -jar $WORKSPACE/apache-jmeter-2.11/lib/ext/CMDRunner.jar --tool Reporter --generate-png $WORKSPACE/reports/getCourseOfferingsByCourse.png --input-jtl $WORKSPACE/reports/svc_course_offering.jtl --plugin-type TimesVsThreads --width 800 --height 600 --include-labels getCourseOfferingsByCourse

java -jar $WORKSPACE/apache-jmeter-2.11/lib/ext/CMDRunner.jar --tool Reporter --generate-png $WORKSPACE/reports/getCourseOfferingsByCourseAndTerm.png --input-jtl $WORKSPACE/reports/svc_course_offering.jtl --plugin-type TimesVsThreads --width 800 --height 600 --include-labels getCourseOfferingsByCourseAndTerm

java -jar $WORKSPACE/apache-jmeter-2.11/lib/ext/CMDRunner.jar --tool Reporter --generate-png $WORKSPACE/reports/getCourseOfferingsByIds.png --input-jtl $WORKSPACE/reports/svc_course_offering.jtl --plugin-type TimesVsThreads --width 800 --height 600 --include-labels getCourseOfferingsByIds

java -jar $WORKSPACE/apache-jmeter-2.11/lib/ext/CMDRunner.jar --tool Reporter --generate-png $WORKSPACE/reports/getCourseOfferingType.png --input-jtl $WORKSPACE/reports/svc_course_offering.jtl --plugin-type TimesVsThreads --width 800 --height 600 --include-labels getCourseOfferingType

java -jar $WORKSPACE/apache-jmeter-2.11/lib/ext/CMDRunner.jar --tool Reporter --generate-png $WORKSPACE/reports/getFormatOffering.png --input-jtl $WORKSPACE/reports/svc_course_offering.jtl --plugin-type TimesVsThreads --width 800 --height 600 --include-labels getFormatOffering

java -jar $WORKSPACE/apache-jmeter-2.11/lib/ext/CMDRunner.jar --tool Reporter --generate-png $WORKSPACE/reports/getFormatOfferingsByCourseOffering.png --input-jtl $WORKSPACE/reports/svc_course_offering.jtl --plugin-type TimesVsThreads --width 800 --height 600 --include-labels getFormatOfferingsByCourseOffering

java -jar $WORKSPACE/apache-jmeter-2.11/lib/ext/CMDRunner.jar --tool Reporter --generate-png $WORKSPACE/reports/getRegistrationGroup.png --input-jtl $WORKSPACE/reports/svc_course_offering.jtl --plugin-type TimesVsThreads --width 800 --height 600 --include-labels getRegistrationGroup

java -jar $WORKSPACE/apache-jmeter-2.11/lib/ext/CMDRunner.jar --tool Reporter --generate-png $WORKSPACE/reports/getRegistrationGroupsByActivityOffering.png --input-jtl $WORKSPACE/reports/svc_course_offering.jtl --plugin-type TimesVsThreads --width 800 --height 600 --include-labels getRegistrationGroupsByActivityOffering

java -jar $WORKSPACE/apache-jmeter-2.11/lib/ext/CMDRunner.jar --tool Reporter --generate-png $WORKSPACE/reports/getRegistrationGroupsByActivityOfferingCluster.png --input-jtl $WORKSPACE/reports/svc_course_offering.jtl --plugin-type TimesVsThreads --width 800 --height 600 --include-labels getRegistrationGroupsByActivityOfferingCluster

java -jar $WORKSPACE/apache-jmeter-2.11/lib/ext/CMDRunner.jar --tool Reporter --generate-png $WORKSPACE/reports/getRegistrationGroupsByFormatOffering.png --input-jtl $WORKSPACE/reports/svc_course_offering.jtl --plugin-type TimesVsThreads --width 800 --height 600 --include-labels getRegistrationGroupsByFormatOffering

java -jar $WORKSPACE/apache-jmeter-2.11/lib/ext/CMDRunner.jar --tool Reporter --generate-png $WORKSPACE/reports/getRegistrationGroupsByIds.png --input-jtl $WORKSPACE/reports/svc_course_offering.jtl --plugin-type TimesVsThreads --width 800 --height 600 --include-labels getRegistrationGroupsByIds

java -jar $WORKSPACE/apache-jmeter-2.11/lib/ext/CMDRunner.jar --tool Reporter --generate-png $WORKSPACE/reports/getRegistrationGroupsForCourseOffering.png --input-jtl $WORKSPACE/reports/svc_course_offering.jtl --plugin-type TimesVsThreads --width 800 --height 600 --include-labels getRegistrationGroupsForCourseOffering

java -jar $WORKSPACE/apache-jmeter-2.11/lib/ext/CMDRunner.jar --tool Reporter --generate-png $WORKSPACE/reports/getRegistrationGroupsWithActivityOfferings.png --input-jtl $WORKSPACE/reports/svc_course_offering.jtl --plugin-type TimesVsThreads --width 800 --height 600 --include-labels getRegistrationGroupsWithActivityOfferings

java -jar $WORKSPACE/apache-jmeter-2.11/lib/ext/CMDRunner.jar --tool Reporter --generate-png $WORKSPACE/reports/getSeatPoolDefinition.png --input-jtl $WORKSPACE/reports/svc_course_offering.jtl --plugin-type TimesVsThreads --width 800 --height 600 --include-labels getSeatPoolDefinition

java -jar $WORKSPACE/apache-jmeter-2.11/lib/ext/CMDRunner.jar --tool Reporter --generate-png $WORKSPACE/reports/getSeatPoolDefinitionsForActivityOffering.png --input-jtl $WORKSPACE/reports/svc_course_offering.jtl --plugin-type TimesVsThreads --width 800 --height 600 --include-labels getSeatPoolDefinitionsForActivityOffering