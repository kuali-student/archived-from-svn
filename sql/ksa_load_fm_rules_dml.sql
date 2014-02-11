


-----------------------------------------------------------------------------------------------------------------------
--- Inserting Fee Managements rules ---
Insert into KSSA_RULE_SET (ID, NAME, RULE_TYPE_ID_FK, HEADER) values (100, 'Fee Management Main', 3,
'import java.util.*;
import java.math.*;
import com.sigmasys.kuali.ksa.model.*;
import com.sigmasys.kuali.ksa.model.fm.*;
import com.sigmasys.kuali.ksa.model.rule.*;
import com.sigmasys.kuali.ksa.service.brm.*;
import com.sigmasys.kuali.ksa.service.fm.*;
import com.sigmasys.kuali.ksa.model.security.*;
import com.sigmasys.kuali.ksa.util.*;
import org.apache.commons.lang.*;

expander ksa.dsl

')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('', 5000, 'FM Main Rule', 3, 20, null,
'(Context is initialized)',
'on each session signup fire "FM Signup 1" rule set
 on session fire "FM Session 1" rule set
 on session fire "FM Session 2" rule set
 on each session signup fire "FM Signup 2" rule set
 on each session signup fire "FM Signup 3" rule set
 on each session signup fire "FM Signup 4" rule set
 on session fire "FM Session 3" rule set
 on session fire "FM Session 4" rule set
')!

-- FM Signup 1 rule set --

Insert into KSSA_RULE_SET (ID, NAME, RULE_TYPE_ID_FK, HEADER) values (101, 'FM Signup 1', 3,
'import java.util.*;
import java.math.*;
import com.sigmasys.kuali.ksa.model.*;
import com.sigmasys.kuali.ksa.model.fm.*;
import com.sigmasys.kuali.ksa.model.rule.*;
import com.sigmasys.kuali.ksa.service.brm.*;
import com.sigmasys.kuali.ksa.service.fm.*;
import com.sigmasys.kuali.ksa.model.security.*;
import com.sigmasys.kuali.ksa.util.*;
import org.apache.commons.lang.*;

expander ksa.dsl

')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('Regular signup add before first day of class.', 5001, 'FM Signup 1_1', 3, 20, null,
'(signup date is on or before atp milestone "kuali.atp.milestone.firstDayOfClass" and signup operation is "ADD")',
'set session key "early.registration" to "true"
 mark signup as taken
')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('Regular signup awop or transfer.', 5002, 'FM Signup 1_2', 3, 20, null,
'(signup operation is "ADD_WITHOUT_PENALTY,TRANSFER_IN")',
'set session key "early.registration" to "true"
 mark signup as taken
')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('Legal drop due to dwop or transfer', 5003, 'FM Signup 1_3', 3, 10, null,
'(signup operation is "DROP_WITHOUT_PENALTY,TRANSFER_OUT")',
'mark preceding offerings as not taken
 mark signup as not taken
 mark preceding offerings as complete
 mark signup as complete
 remove signup rates ".*fee.*"
 remove rates ".*fee.*" from preceding offerings
')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('withdrawal at 80 percent', 5004, 'FM Signup 1_4', 3, 10, null,
'(signup operation is "WITHDRAW" and signup date is after atp milestone "kuali.atp.milestone.withdraw80")',
'set session key "withdrawn" to "yes"
 set session key "80percent" to "yes"
')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('withdrawal at 60 percent', 5005, 'FM Signup 1_5', 3, 10, null,
'(signup operation is "WITHDRAW" and signup date is after atp milestone "kuali.atp.milestone.withdraw60")',
'set session key "withdrawn" to "yes"
 set session key "60percent" to "yes"
')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('withdrawal at 40 percent', 5006, 'FM Signup 1_6', 3, 10, null,
'(signup operation is "WITHDRAW" and signup date is after atp milestone "kuali.atp.milestone.withdraw40")',
'set session key "withdrawn" to "yes"
 set session key "40percent" to "yes"
')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('withdrawal at 20 percent', 5007, 'FM Signup 1_7', 3, 10, null,
'(signup operation is "WITHDRAW" and signup date is after atp milestone "kuali.atp.milestone.withdraw20")',
'set session key "withdrawn" to "yes"
 set session key "20percent" to "yes"
')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('withdrawal at 0 percent', 5008, 'FM Signup 1_8', 3, 10, null,
'(signup operation is "WITHDRAW" and signup date is after atp milestone "kuali.atp.milestone.withdraw0")',
'set session key "withdrawn" to "yes"
 set session key "0percent" to "yes"
')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('Legal drop before first day of class', 5009, 'FM Signup 1_9', 3, 10, null,
'(signup operation is "DROP" and signup date is before atp milestone "kuali.atp.milestone.firstDayOfClass")',
'mark preceding offerings as not taken
 mark signup as not taken
 mark preceding offerings as complete
 mark signup as complete
 remove signup rates ".*fee.*"
 remove rates ".*fee.*" from preceding offerings
')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('Penalty drop', 5010, 'FM Signup 1_10', 3, 10, null,
'(signup operation is "DROP" and signup date is on or after atp milestone "kuali.atp.milestone.firstDayOfClass" and signup date is on or before atp milestone "kuali.atp.milestone.lastDayForPenaltyDrop")',
'mark preceding offerings as not taken
mark signup as not taken
set signup key "late.drop.penalty" to "yes"
set session key "late.drop.penalty" to "yes"
mark signup as complete
')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('Late drop - ignored', 5011, 'FM Signup 1_11', 3, 10, null,
'(signup operation is "DROP" and signup date is after atp milestone "kuali.atp.milestone.lastDayForPenaltyDrop")',
'mark signup as complete')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('Withdrawal trigger', 5012, 'FM Signup 1_12', 3, 10, null,
'(signup operation is "WITHDRAW")',
'set session key "withdrawn" to "yes"')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('Student is in an MBA section so remove incompatible regular tuition rate.', 5013, 'FM Signup 1_13', 3, 10, null,
'(signup has rates "mba.cohort.flag, regular" and session key "cohort.code" is "EM.." and session key "major.code" is ".*MBA")',
'remove signup rates "regular"')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('Student is in MBA classes but is not MBA student so remove MBA rate', 5014, 'FM Signup 1_14', 3, 10, null,
'(signup has rates "mba.cohort.flag, regular" and session key "cohort.code" is not "EM..")',
'remove signup rates "mba.cohort.flag"')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('Student is not MBA so remove cohort rates', 5015, 'FM Signup 1_15', 3, 10, null,
'(session key "major.code" is not ".*MBA")',
'remove signup rates "mba.cohort.flag"')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('Student is not a Cybersecurity student to remove that rate', 5016, 'FM Signup 1_16', 3, 10, null,
'(session key "major.code" is not "z077")',
'remove signup rates "cybersecurity.leadership"')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('Student is resident Public Policy student so remove regular and add pp', 5017, 'FM Signup 1_17', 3, 10, null,
'(session key "major.code" is "mapo|mamg|mpps|bmpo|posi|lmpo" and signup key "residency" is "in.state")',
'remove signup rates "regular"
 add signup rate "public.policy.resident", "default"
 add signup rate "public.policy.resident.differential", "default"
')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('Student is nonresident Public Policy student so remove regular and add pp', 5018, 'FM Signup 1_18', 3, 10, null,
'(session key "major.code" is "mapo|mamg|mpps|bmpo|posi|lmpo" and signup key "residency" is "out.of.state")',
'remove signup rates "regular"
 add signup rate "public.policy.resident", "default"
 add signup rate "public.policy.resident.differential", "default"
')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('Late add', 5019, 'FM Signup 1_19', 3, 20, null,
'(signup date is after atp milestone "kuali.atp.milestone.firstDayOfClass" and signup operation is "ADD")',
'set session key "late.registration" to "true"
 mark signup as taken
')!


--Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('', 9099, 'FM Rule TEST', 3, 8, null,
--'(Context is initialized)',
--'set session key "chargeable.credits" to number of units where signup operation is "ADD,ADD_WITHOUT_PENALTY,TRANSFER_IN" minus "DROP,DROP_WITHOUT_PENALTY,TRANSFER_OUT"
-- set session key "taken.credits" to number of units where signup is taken
--mark preceding offerings as not taken
--mark signup as not taken
--mark signup as not complete
--remove rates ".*fee.*" from preceding offerings
--charge incidental rate "late.registration", "1" using id "late.registration"
--charge rates "late.registration", "1" in amount of 34.56% with types "", catalogs "", signup operations ""
--charge rates "late.registration", "" with types "", catalogs "", signup operations ""
--discount rate "late.registration", "1" by $10.67
--discount rate "late.registration", "1" by 99.91%
--replace signup rates ".*,late.fee,2", "" with "late.registration", "1"
--remove signup rates ".*"
--add signup rate "late.registration", "1"
--replace signup rates ".*,late.fee,2", "" with "late.registration", "1"
--remove signup rates ".*"
--add signup rate "late.registration", "1"
--mark signup rates ".*", "1" as not complete
--mark signup rates "late.registration", "1" as complete with types "", catalogs "", signup operations ""
--mark signup rates ".*", "1" as complete
--mark signup rates "late.registration", "" as not complete
--mark signup rates ".*", "" as not complete
--add rate "late.registration", "1" to signups with rates ".*", ".*", types "", catalogs "", signup operations ""
--mark session as review required
--mark session as review complete
--')!

-- FM Session 1 rule set --

Insert into KSSA_RULE_SET (ID, NAME, RULE_TYPE_ID_FK, HEADER) values (102, 'FM Session 1', 3,
'import java.util.*;
import java.math.*;
import com.sigmasys.kuali.ksa.model.*;
import com.sigmasys.kuali.ksa.model.fm.*;
import com.sigmasys.kuali.ksa.model.rule.*;
import com.sigmasys.kuali.ksa.service.brm.*;
import com.sigmasys.kuali.ksa.service.fm.*;
import com.sigmasys.kuali.ksa.model.security.*;
import com.sigmasys.kuali.ksa.util.*;
import org.apache.commons.lang.*;

expander ksa.dsl

')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('Late fee charge', 6001, 'FM Session 1_1', 3, 10, null,
'(signup operation is "ADD" and signup date is after atp milestone "kuali.atp.milestone.firstDayOfClass" and session key "early.registration" is not "true")',
'charge incidental rate "late.fee", "default" using id "late.fee"')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('UG student has more than 12 units so is full time', 6002, 'FM Session 1_2', 3, 10, null,
'(number of taken units gte 12 with rates "", types "", signup operations "" and student is undergraduate)',
'set session key "study.load" to "ft"')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('Grad student has over 9 units so is full time', 6003, 'FM Session 1_3', 3, 10, null,
'(number of taken units gte 9 with rates "", types "", signup operations "" and student is graduate)',
'set session key "study.load" to "ft"')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('Doctoral student has over 9 units so is full time', 6004, 'FM Session 1_4', 3, 10, null,
'(number of taken units gte 9 with rates "", types "", signup operations "" and session key "study.level" is "doctoral")',
'set session key "study.load" to "ft"')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('UG student is under 12 units so is part time', 6005, 'FM Session 1_5', 3, 10, null,
'(number of taken units lt 12 with rates "", types "", signup operations "" and student is undergraduate)',
'set session key "study.load" to "pt"')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('Grad student is under 9 unis so is part time', 6006, 'FM Session 1_6', 3, 10, null,
'(number of taken units lt 9 with rates "", types "", signup operations "" and student is graduate)',
'set session key "study.load" to "pt"')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('Doctoral student is under 9 units so is part time', 6007, 'FM Session 1_7', 3, 10, null,
'(number of taken units lt 9 with rates "", types "", signup operations "" and session key "study.level" is "doctoral")',
'set session key "study.load" to "pt"')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('cybersecurity rate applied', 6008, 'FM Session 1_8', 3, 10, null,
'(session key "major.code" is "z077" and signup has rates "cybersecurity.leadership")',
'remove signup rates "regular"')!


-- FM Session 2 rule set --

Insert into KSSA_RULE_SET (ID, NAME, RULE_TYPE_ID_FK, HEADER) values (103, 'FM Session 2', 3,
'import java.util.*;
import java.math.*;
import com.sigmasys.kuali.ksa.model.*;
import com.sigmasys.kuali.ksa.model.fm.*;
import com.sigmasys.kuali.ksa.model.rule.*;
import com.sigmasys.kuali.ksa.service.brm.*;
import com.sigmasys.kuali.ksa.service.fm.*;
import com.sigmasys.kuali.ksa.model.security.*;
import com.sigmasys.kuali.ksa.util.*;
import org.apache.commons.lang.*;

expander ksa.dsl

')!


Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('Student has ENGF major so gets enpm tuition rates', 6050, 'FM Session 2_1', 3, 8, null,
'(session key "major.code" is "engf")',
'replace signup rates "regular", "" with "enpm", "default"')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('Student is undergrad full time resident so is charged those tuition rates - CP.', 6051, 'FM Session 2_2', 3, 8, null,
'(student is full-time and student is resident and student is undergraduate and session key "campus" is "cp")',
'replace signup rates "regular", "" with "cp.undergrad.resident.ft", "default"')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('Student is grad full time resident so is charged those tuition rates - CP.', 6052, 'FM Session 2_3', 3, 8, null,
'(student is full-time and student is resident and student is graduate and session key "campus" is "cp")',
'replace signup rates "regular", "" with "cp.graduate.resident.ft", "default"')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('Student is undergrad full time nonresident so is charged those tuition rates - CP.', 6053, 'FM Session 2_4', 3, 8, null,
'(student is full-time and student is nonresident and student is undergraduate and session key "campus" is "cp")',
'replace signup rates "regular", "" with "cp.undergrad.nonresident.ft", "default"')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('Student is grad full time nonresident so is charged those tuition rates - CP.', 6054, 'FM Session 2_5', 3, 8, null,
'(student is full-time and student is nonresident and student is graduate and session key "campus" is "cp")',
'replace signup rates "regular", "" with "cp.graduate.nonresident.ft", "default"')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('Student is undergrad part-time resident so is charged those tuition rates - CP.', 6055, 'FM Session 2_6', 3, 8, null,
'(student is part-time and student is resident and student is undergraduate and session key "campus" is "cp")',
'replace signup rates "regular", "" with "cp.undergrad.resident.pt", "default"')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('Student is grad part-time resident so is charged those tuition rates - CP.', 6056, 'FM Session 2_7', 3, 8, null,
'(student is part-time and student is resident and student is graduate and session key "campus" is "cp")',
'replace signup rates "regular", "" with "cp.graduate.resident.pt", "default"')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('Student is undergrad part-time nonresident so is charged those tuition rates - CP.', 6057, 'FM Session 2_8', 3, 8, null,
'(student is part-time and student is nonresident and student is undergraduate and session key "campus" is "cp")',
'replace signup rates "regular", "" with "cp.undergrad.nonresident.pt", "default"')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('Student is grad part-time nonresident so is charged those tuition rates - CP.', 6058, 'FM Session 2_9', 3, 8, null,
'(student is part-time and student is nonresident and student is graduate and session key "campus" is "cp")',
'replace signup rates "regular", "" with "cp.graduate.nonresident.pt", "default"')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('Student is shady grove ug resident so charge that rate', 6059, 'FM Session 2_10', 3, 8, null,
'(student is resident and student is undergraduate and session key "campus" is "sg")',
'replace signup rates "regular", "" with "sg.undergrad.resident", "default"')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('Student is shady grove ug nonresident so charge that rate', 6060, 'FM Session 2_11', 3, 8, null,
'(student is nonresident and student is undergraduate and session key "campus" is "sg")',
'replace signup rates "regular", "" with "sg.undergrad.nonresident", "default"')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('Student is shady grove grad resident so charge that rate', 6061, 'FM Session 2_12', 3, 8, null,
'(student is resident and student is graduate and session key "campus" is "sg")',
'replace signup rates "regular", "" with "sg.graduate.resident", "default"')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('Student is shady grove grad nonresident so charge that rate', 6062, 'FM Session 2_13', 3, 8, null,
'(student is nonresident and student is graduate and session key "campus" is "sg")',
'replace signup rates "regular", "" with "sg.graduate.nonresident", "default"')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('em11 cohort rate applied', 6063, 'FM Session 2_14', 3, 8, null,
'(session key "cohort.code" is "EM11" and session key "major.code" is ".*MBA")',
'replace signup rates "mba.cohort.flag", "" with "mba.cohort.em11", "default"')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('em12 cohort rate applied', 6064, 'FM Session 2_15', 3, 8, null,
'(session key "cohort.code" is "EM12" and session key "major.code" is ".*MBA")',
'replace signup rates "mba.cohort.flag", "" with "mba.cohort.em12", "default"')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('Full time resident CP fees applied', 6065, 'FM Session 2_16', 3, 8, null,
'(student is full-time and student is resident)',
'replace signup rates "cp.mandatory.fee.flag", "" with "cp.resident.ft", "default"')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('Full time nonresident CP fees applied', 6066, 'FM Session 2_17', 3, 8, null,
'(student is full-time and student is nonresident)',
'replace signup rates "cp.mandatory.fee.flag", "" with "cp.nonresident.ft", "default"')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('Part time resident CP fees applied', 6067, 'FM Session 2_18', 3, 8, null,
'(student is part-time and student is resident)',
'replace signup rates "cp.mandatory.fee.flag", "" with "cp.resident.pt", "default"')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('Part time nonresident CP fees applied', 6068, 'FM Session 2_19', 3, 8, null,
'(student is part-time and student is nonresident)',
'replace signup rates "cp.mandatory.fee.flag", "" with "cp.nonresident.pt", "default"')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('Full time tech fee applied', 6069, 'FM Session 2_20', 3, 8, null,
'(signup has rates "tech.fee.flag" and student is full-time)',
'replace signup rates "tech.fee.flag", "" with "tech.fee.ft", "default"')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('Part time tech fee applied', 6070, 'FM Session 2_21', 3, 8, null,
'(signup has rates "tech.fee.flag" and student is part-time)',
'replace signup rates "tech.fee.flag", "" with "tech.fee.pt", "default"')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('Graduate art fee replaces undergrad art fee', 6071, 'FM Session 2_22', 3, 8, null,
'(student is graduate and signup has rates "art.ug")',
'replace signup rates "art.ug", "" with "art.grad", "default"')!


-- FM Signup 2 rule set --

Insert into KSSA_RULE_SET (ID, NAME, RULE_TYPE_ID_FK, HEADER) values (160, 'FM Signup 2', 3,
'import java.util.*;
import java.math.*;
import com.sigmasys.kuali.ksa.model.*;
import com.sigmasys.kuali.ksa.model.fm.*;
import com.sigmasys.kuali.ksa.model.rule.*;
import com.sigmasys.kuali.ksa.service.brm.*;
import com.sigmasys.kuali.ksa.service.fm.*;
import com.sigmasys.kuali.ksa.model.security.*;
import com.sigmasys.kuali.ksa.util.*;
import org.apache.commons.lang.*;

expander ksa.dsl

')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('Academic service fee is to be removed', 7001, 'FM Signup 2_1', 3, 10, null,
'(signup is taken and signup does not have rates "academic.service.fee")',
'set session key "academic.service.remove" to "y"')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('Student is SG and incurs SG reg fee', 7002, 'FM Signup 2_2', 3, 10, null,
'(session key "campus" is "sg" and signup has rates "sg.fee" and student is full-time and student is undergraduate)',
'add signup rate "sg.facilities.ft", "default"
 ')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('Student is SG and incurs SG reg fee', 7003, 'FM Signup 2_3', 3, 10, null,
'(session key "campus" is "sg" and signup has rates "sg.fee" and student is part-time and student is undergraduate)',
'add signup rate "sg.facilities.pt", "default"
')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('Student is SG and incurs SG reg fee', 7004, 'FM Signup 2_4', 3, 10, null,
'(session key "campus" is "sg" and signup has rates "sg.fee" and student is full-time and student is graduate)',
'add signup rate "sg.facilities.ft", "default"
 add signup rate "sg.fee.graduate.ft", "default"
 remove signup rates "sg.fee"
')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('Student is SG and incurs SG reg fee', 7005, 'FM Signup 2_5', 3, 10, null,
'(session key "campus" is "sg" and signup has rates "sg.fee" and student is part-time and student is graduate)',
'add signup rate "sg.facilities.pt", "default"
 add signup rate "sg.fee.graduate.pt", "default"
  remove signup rates "sg.fee"
')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('Frostburg student receives discount major 0909F', 7006, 'FM Signup 2_6', 3, 10, null,
'(session key "major.code" is "0909F" and signup has rates "cp.undergrad.resident.ft")',
'add signup rate "cp.undergrad.resident.ft.frostburg.discount", "default"')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('Frostburg student receives discount major 0909F', 7007, 'FM Signup 2_7', 3, 10, null,
'(session key "major.code" is "0909F" and signup has rates "cp.undergrad.resident.pt")',
'add signup rate "cp.undergrad.resident.pt.frostburg.discount", "default"')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('Frostburg student receives discount major 0909F', 7008, 'FM Signup 2_8', 3, 10, null,
'(session key "major.code" is "0909F" and signup has rates "cp.undergrad.nonresident.ft")',
'add signup rate "cp.undergrad.nonresident.ft.frostburg.discount", "default"')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('Frostburg student receives discount major 0909F', 7009, 'FM Signup 2_9', 3, 10, null,
'(session key "major.code" is "0909F" and signup has rates "cp.undergrad.nonresident.pt")',
'add signup rate "cp.undergrad.nonresident.pt.frostburg.discount", "default"')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('Student already has mandatory fees so incurred tech fees removed', 7010, 'FM Signup 2_10', 3, 10, null,
'(signup has rates "tech.fee.[..]" and signup has rates "cp.[.*graduate].[..]")',
'remove signup rates "tech.fee.[..]"')!


-- FM Signup 3 rule set --

Insert into KSSA_RULE_SET (ID, NAME, RULE_TYPE_ID_FK, HEADER) values (170, 'FM Signup 3', 3,
'import java.util.*;
import java.math.*;
import com.sigmasys.kuali.ksa.model.*;
import com.sigmasys.kuali.ksa.model.fm.*;
import com.sigmasys.kuali.ksa.model.rule.*;
import com.sigmasys.kuali.ksa.service.brm.*;
import com.sigmasys.kuali.ksa.service.fm.*;
import com.sigmasys.kuali.ksa.model.security.*;
import com.sigmasys.kuali.ksa.util.*;
import org.apache.commons.lang.*;

expander ksa.dsl

')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('Illegal drop does not affect calculation so is ignored', 7040, 'FM Signup 3_1', 3, 5, null,
'(signup operation is "DROP" and signup key "late.drop.penalty" is "yes" and signup has rates "cp.undergrad.resident.ft,cp.graduate.resident.ft,cp.undergrad.nonresident.ft")',
'mark signup as complete')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('Illegal drop does not affect calculation so is ignored', 7041, 'FM Signup 3_2', 3, 5, null,
'(signup operation is "DROP" and signup key "late.drop.penalty" is "yes" and signup has rates "mba.cohort.em11" and manifest has rates "mba.cohort.em11")',
'mark signup as complete')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('Illegal drop does not affect calculation so is ignored', 7042, 'FM Signup 3_3', 3, 5, null,
'(signup operation is "DROP" and signup key "late.drop.penalty" is "yes" and signup has rates "mba.cohort.em12" and manifest has rates "mba.cohort.em12")',
'mark signup as complete')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('Illegal drop does not affect calculation so is ignored', 7043, 'FM Signup 3_4', 3, 5, null,
'(signup operation is "DROP" and signup key "late.drop.penalty" is "yes" and signup has rates "mba.cohort.em13" and manifest has rates "mba.cohort.em13")',
'mark signup as complete')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('Illegal drop does not affect calculation so is ignored', 7044, 'FM Signup 3_5', 3, 5, null,
'(signup operation is "DROP" and signup key "late.drop.penalty" is "yes" and signup has rates "mba.cohort.ac01" and manifest has rates "mba.cohort.ac01")',
'mark signup as complete')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('All academic service fees are removed due to more than ESL classes being taken', 7045, 'FM Signup 3_6', 3, 9, null,
'(session key "academic.service.remove" is "y")',
'remove signup rates "academic.service.fee"')!


-- FM Signup 4 rule set --

Insert into KSSA_RULE_SET (ID, NAME, RULE_TYPE_ID_FK, HEADER) values (180, 'FM Signup 4', 3,
'import java.util.*;
import java.math.*;
import com.sigmasys.kuali.ksa.model.*;
import com.sigmasys.kuali.ksa.model.fm.*;
import com.sigmasys.kuali.ksa.model.rule.*;
import com.sigmasys.kuali.ksa.service.brm.*;
import com.sigmasys.kuali.ksa.service.fm.*;
import com.sigmasys.kuali.ksa.model.security.*;
import com.sigmasys.kuali.ksa.util.*;
import org.apache.commons.lang.*;

expander ksa.dsl

')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('Illegal drop incurs 20 percent penalty', 7070, 'FM Signup 4_1', 3, 4, null,
'(signup operation is "DROP" and signup key "late.drop.penalty" is "yes" and signup has rates "mba.cohort.ac01")',
'charge rates "mba.cohort.ac01", "" in amount of 20% with types "", catalogs "", signup operations "DROP"')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('Illegal drop incurs 20 percent penalty', 7071, 'FM Signup 4_2', 3, 4, null,
'(signup operation is "DROP" and signup key "late.drop.penalty" is "yes" and signup has rates "mba.cohort.em11")',
'charge rates "mba.cohort.em11", "" in amount of 20% with types "", catalogs "", signup operations "DROP"')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('Illegal drop incurs 20 percent penalty', 7072, 'FM Signup 4_3', 3, 4, null,
'(signup operation is "DROP" and signup key "late.drop.penalty" is "yes" and signup has rates "mba.cohort.em12")',
'charge rates "mba.cohort.em12", "" in amount of 20% with types "", catalogs "", signup operations "DROP"')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('Illegal drop incurs 20 percent penalty', 7073, 'FM Signup 4_4', 3, 4, null,
'(signup operation is "DROP" and signup key "late.drop.penalty" is "yes" and signup has rates "mba.cohort.em13")',
'charge rates "mba.cohort.em13", "" in amount of 20% with types "", catalogs "", signup operations "DROP"')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('Illegal drop incurs 20 percent penalty', 7074, 'FM Signup 4_5', 3, 5, null,
'(signup operation is "DROP" and signup key "late.drop.penalty" is "yes" and signup has rates "cp.undergrad.resident.pt")',
'charge rates "cp.undergrad.resident.pt", "" in amount of 20% with types "", catalogs "", signup operations "DROP"')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('Illegal drop incurs 20 percent penalty', 7075, 'FM Signup 4_6', 3, 5, null,
'(signup operation is "DROP" and signup key "late.drop.penalty" is "yes" and signup has rates "cp.graduate.resident.pt")',
'charge rates "cp.graduate.resident.pt", "" in amount of 20% with types "", catalogs "", signup operations "DROP"')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('Illegal drop incurs 20 percent penalty', 7076, 'FM Signup 4_7', 3, 5, null,
'(signup operation is "DROP" and signup key "late.drop.penalty" is "yes" and signup has rates "cp.undergrad.nonresident.pt")',
'charge rates "cp.undergrad.nonresident.pt", "" in amount of 20% with types "", catalogs "", signup operations "DROP"')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('Illegal drop incurs 20 percent penalty', 7077, 'FM Signup 4_8', 3, 5, null,
'(signup operation is "DROP" and signup key "late.drop.penalty" is "yes" and signup has rates "cp.graduate.nonresident.pt")',
'charge rates "cp.graduate.nonresident.pt", "" in amount of 20% with types "", catalogs "", signup operations "DROP"')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('Illegal drop incurs 20 percent penalty', 7078, 'FM Signup 4_9', 3, 5, null,
'(signup operation is "DROP" and signup key "late.drop.penalty" is "yes" and signup has rates "sg.grad.resident")',
'charge rates "sg.grad.resident", "" in amount of 20% with types "", catalogs "", signup operations "DROP"')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('Illegal drop incurs 20 percent penalty', 7079, 'FM Signup 4_10', 3, 5, null,
'(signup operation is "DROP" and signup key "late.drop.penalty" is "yes" and signup has rates "sg.grad.nonresident")',
'charge rates "sg.grad.nonresident", "" in amount of 20% with types "", catalogs "", signup operations "DROP"')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('Illegal drop incurs 20 percent penalty', 7080, 'FM Signup 4_11', 3, 5, null,
'(signup operation is "DROP" and signup key "late.drop.penalty" is "yes" and signup has rates "baltimore.mba")',
'charge rates "baltimore.mba", "" in amount of 20% with types "", catalogs "", signup operations "DROP"')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('Illegal drop incurs 20 percent penalty', 7081, 'FM Signup 4_12', 3, 5, null,
'(signup operation is "DROP" and signup key "late.drop.penalty" is "yes" and signup has rates "public.policy.resident")',
'charge rates "public.policy.resident", "" in amount of 20% with types "", catalogs "", signup operations "DROP"')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('Illegal drop incurs 20 percent penalty', 7082, 'FM Signup 4_13', 3, 5, null,
'(signup operation is "DROP" and signup key "late.drop.penalty" is "yes" and signup has rates "public.policy.resident.differential")',
'charge rates "public.policy.resident.differential", "" in amount of 20% with types "", catalogs "", signup operations "DROP"')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('Illegal drop incurs 20 percent penalty', 7083, 'FM Signup 4_14', 3, 5, null,
'(signup operation is "DROP" and signup key "late.drop.penalty" is "yes" and signup has rates "public.policy.nonresident")',
'charge rates "public.policy.nonresident", "" in amount of 20% with types "", catalogs "", signup operations "DROP"')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('Illegal drop incurs 20 percent penalty', 7084, 'FM Signup 4_15', 3, 5, null,
'(signup operation is "DROP" and signup key "late.drop.penalty" is "yes" and signup has rates "public.policy.nonresident.differential")',
'charge rates "public.policy.nonresident.differential", "" in amount of 20% with types "", catalogs "", signup operations "DROP"')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('Illegal drop incurs 20 percent penalty', 7085, 'FM Signup 4_16', 3, 5, null,
'(signup operation is "DROP" and signup key "late.drop.penalty" is "yes" and signup has rates "cybersecurity.leadership")',
'charge rates "cybersecurity.leadership", "" in amount of 20% with types "", catalogs "", signup operations "DROP"')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('Illegal drop incurs 20 percent penalty', 7086, 'FM Signup 4_17', 3, 5, null,
'(signup operation is "DROP" and signup key "late.drop.penalty" is "yes" and signup has rates "enpm")',
'charge rates "enpm", "" in amount of 20% with types "", catalogs "", signup operations "DROP"')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('Illegal drop incurs 20 percent penalty', 7087, 'FM Signup 4_18', 3, 5, null,
'(signup operation is "DROP" and signup key "late.drop.penalty" is "yes" and signup has rates "dc.weekend")',
'charge rates "dc.weekend", "" in amount of 20% with types "", catalogs "", signup operations "DROP"')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('Illegal drop incurs 20 percent penalty', 7088, 'FM Signup 4_19', 3, 5, null,
'(signup operation is "DROP" and signup key "late.drop.penalty" is "yes" and signup has rates "dc.weeknight")',
'charge rates "dc.weeknight", "" in amount of 20% with types "", catalogs "", signup operations "DROP"')!


-- FM Session 3 rule set --

Insert into KSSA_RULE_SET (ID, NAME, RULE_TYPE_ID_FK, HEADER) values (190, 'FM Session 3', 3,
'import java.util.*;
import java.math.*;
import com.sigmasys.kuali.ksa.model.*;
import com.sigmasys.kuali.ksa.model.fm.*;
import com.sigmasys.kuali.ksa.model.rule.*;
import com.sigmasys.kuali.ksa.service.brm.*;
import com.sigmasys.kuali.ksa.service.fm.*;
import com.sigmasys.kuali.ksa.model.security.*;
import com.sigmasys.kuali.ksa.util.*;
import org.apache.commons.lang.*;

expander ksa.dsl

')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('Charge regular tuition', 8001, 'FM Session 3_1', 3, 6, null,
'(Context is initialized)',
'charge rates "", "" with types "tuition.credits.fixed,tuition.flat", catalogs "", signup operations "ADD,ADD_WITHOUT_PENALTY,TRANSFER_IN"')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('Charge regular fees', 8002, 'FM Session 3_2', 3, 8, null,
'(Context is initialized)',
'charge rates "", "" with types ".*fee.*", catalogs "", signup operations "ADD,ADD_WITHOUT_PENALTY,TRANSFER_IN"')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('Charge 80 percent withdrawal rate', 8003, 'FM Session 3_3', 3, 10, null,
'(session key "80percent" is "yes")',
'charge rates "", "" in amount of 20% with types "tuition.credits.fixed", catalogs "", signup operations "WITHDRAW"
 charge rates "mba.cohort..*", "" in amount of 20% with types "", catalogs "", signup operations "WITHDRAW"
')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('Charge 60 percent withdrawal rate', 8004, 'FM Session 3_4', 3, 10, null,
'(session key "60percent" is "yes")',
'charge rates "", "" in amount of 40% with types "tuition.credits.fixed", catalogs "", signup operations "WITHDRAW"
 charge rates "mba.cohort..*", "" in amount of 40% with types "", catalogs "", signup operations "WITHDRAW"
')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('Charge 40 percent withdrawal rate', 8005, 'FM Session 3_5', 3, 10, null,
'(session key "40percent" is "yes")',
'charge rates "", "" in amount of 60% with types "tuition.credits.fixed", catalogs "", signup operations "WITHDRAW"
 charge rates "mba.cohort..*", "" in amount of 60% with types "", catalogs "", signup operations "WITHDRAW"
')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('Charge 20 percent withdrawal rate', 8006, 'FM Session 3_6', 3, 10, null,
'(session key "20percent" is "yes")',
'charge rates "", "" in amount of 80% with types "tuition.credits.fixed", catalogs "", signup operations "WITHDRAW"
 charge rates "mba.cohort..*", "" in amount of 80% with types "", catalogs "", signup operations "WITHDRAW"
')!

-- FM Session 4 Java-based rule set --

Insert into KSSA_RULE_SET (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, HEADER) values ('Special drop rule for limit rates', 200, 'FM Session 4', 2,
'import java.util.*;
import java.math.*;
import com.sigmasys.kuali.ksa.model.*;
import com.sigmasys.kuali.ksa.model.fm.*;
import com.sigmasys.kuali.ksa.model.rule.*;
import com.sigmasys.kuali.ksa.service.brm.*;
import com.sigmasys.kuali.ksa.service.fm.*;
import com.sigmasys.kuali.ksa.model.security.*;
import com.sigmasys.kuali.ksa.util.*;
import org.apache.commons.lang.*;

')!

Insert into KSSA_RULE (DESCRIPTION, ID, NAME, RULE_TYPE_ID_FK, PRIORITY, HEADER, LHS, RHS) values ('', 9001, 'FM Session 4_1', 2, 10, null,
'context : BrmContext(fmService.compareSessionKeyPair("late.drop.penalty","yes","==",context))',
'
        String[] rateCodes = {
                          "cp.undergrad.resident.pt",
                          "cp.undergrad.nonresident.pt",
                          "cp.graduate.resident.pt",
                          "cp.graduate.nonresident.pt"
                 };

        final UnitNumber threshold = new UnitNumber(12);

        final UnitNumber five = new UnitNumber(5);

        for (int i = 0; i < rateCodes.length; i++) {

            UnitNumber numberOfDroppedUnits = context.getFmService().countDroppedUnits(rateCodes[i], context);
            UnitNumber numberOfTakenUnits = context.getFmService().countTakenUnits(rateCodes[i], context);

            UnitNumber numberOfUnits = numberOfTakenUnits.add(numberOfDroppedUnits);

            if (numberOfUnits.compareTo(threshold) > 0) {
                numberOfDroppedUnits = numberOfDroppedUnits.subtract(numberOfUnits.subtract(threshold));
            }

            UnitNumber numberOfUnitsToCharge = numberOfDroppedUnits.divide(five);

            if (numberOfUnitsToCharge.compareTo(UnitNumber.ZERO) > 0) {
               context.getFmService().chargeIncidentalRate(rateCodes[i], "default", rateCodes[i] + ".default", numberOfUnitsToCharge, null, context);
            }
        }
')!

-- FM rule associations
-- Main rule set
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (100, 5000)!

-- FM Signup 1 rule set --
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (101, 5001)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (101, 5002)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (101, 5003)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (101, 5004)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (101, 5005)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (101, 5006)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (101, 5007)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (101, 5008)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (101, 5009)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (101, 5010)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (101, 5011)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (101, 5012)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (101, 5013)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (101, 5014)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (101, 5015)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (101, 5016)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (101, 5017)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (101, 5018)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (101, 5019)!
--Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (101, 9099)!

-- FM Session 1 rule set --
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (102, 6001)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (102, 6002)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (102, 6003)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (102, 6004)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (102, 6005)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (102, 6006)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (102, 6007)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (102, 6008)!

-- FM Session 2 rule set --
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (103, 6050)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (103, 6051)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (103, 6052)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (103, 6053)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (103, 6054)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (103, 6055)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (103, 6056)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (103, 6057)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (103, 6058)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (103, 6059)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (103, 6060)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (103, 6061)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (103, 6062)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (103, 6063)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (103, 6064)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (103, 6065)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (103, 6066)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (103, 6067)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (103, 6068)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (103, 6069)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (103, 6070)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (103, 6071)!

-- FM Signup 2 rule set --
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (160, 7001)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (160, 7002)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (160, 7003)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (160, 7004)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (160, 7005)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (160, 7006)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (160, 7007)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (160, 7008)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (160, 7009)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (160, 7010)!

-- FM Signup 3 rule set --
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (170, 7040)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (170, 7041)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (170, 7042)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (170, 7043)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (170, 7044)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (170, 7045)!

-- FM Signup 4 rule set --
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (180, 7070)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (180, 7071)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (180, 7072)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (180, 7073)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (180, 7074)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (180, 7075)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (180, 7076)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (180, 7077)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (180, 7078)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (180, 7079)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (180, 7080)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (180, 7081)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (180, 7082)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (180, 7083)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (180, 7084)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (180, 7085)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (180, 7086)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (180, 7087)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (180, 7088)!

-- FM Session 3 rule set --
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (190, 8001)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (190, 8002)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (190, 8003)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (190, 8004)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (190, 8005)!
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (190, 8006)!

-- FM Session 4 rule set --
Insert into KSSA_RULE_SET_RULE ( RULE_SET_ID_FK, RULE_ID_FK ) values (200, 9001)!


-----------------------------------------------------------------------------------------------------------------------