package org.kuali.student.loader.rules;

import org.kuali.rice.krms.api.repository.term.TermDefinition;
import org.kuali.rice.krms.api.repository.term.TermParameterDefinition;
import org.kuali.rice.krms.api.repository.term.TermRepositoryService;
import org.kuali.student.r2.common.dto.ContextInfo;
import org.kuali.student.r2.core.krms.naturallanguage.TermParameterTypes;
import org.kuali.student.r2.lum.clu.dto.CluSetInfo;
import org.kuali.student.r2.lum.clu.service.CluService;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created with IntelliJ IDEA.
 * User: christoff
 * Date: 2013/05/22
 */
public class RulesDataCOCopyCluSetFix {
    ContextInfo contextInfo;
    private CluService cluService;
    private TermRepositoryService termRepositoryService;
    private Map<String, List<TermTermParamInfo>> cluSetMap;

    RulesDataCOCopyCluSetFix() {
        contextInfo = new ContextInfo();
        contextInfo.setPrincipalId("RULECLUSETFIX");
        contextInfo.setCurrentDate(new Date());
        cluSetMap = new HashMap<String, List<TermTermParamInfo>>();
        populateCluSetMap();
    }

    public void setCluService(CluService cluService) {
        this.cluService = cluService;
    }

    public void setTermRepositoryService(TermRepositoryService termRepositoryService) {
        this.termRepositoryService = termRepositoryService;
    }

    public void startClusetFix() {
        int total = cluSetMap.keySet().size();
        int i = 0;
        for (String cluSetID : cluSetMap.keySet()) {

            i++;
            System.out.println("Processing: "+i+"/"+total + " --------------------------------------");
            List<TermTermParamInfo> infos = cluSetMap.get(cluSetID);
            System.out.println("Cluset: "+cluSetID + " with "+ infos.size()+ " item(s)");
            if(infos.size() > 1){//we want to change all but the first one
                for (int j = 1; j < infos.size();j++) {
                    TermTermParamInfo termTermParamInfo = infos.get(j);
                    TermDefinition termDef = termRepositoryService.getTerm(termTermParamInfo.getTermId());
                    fixTermParams(termDef,termTermParamInfo.getTermParamId());
                }
            }
        }

    }

    private void fixTermParams(TermDefinition termDef,String termParamId) {
        TermDefinition.Builder termBldr = TermDefinition.Builder.create(termDef);
        System.out.println("Term: "+termBldr.getId());
        for (TermParameterDefinition.Builder termParmBldr : termBldr.getParameters()) {
            if(!termParamId.equals(termParmBldr.getId())){
                System.out.println("------SKIPPING Term param: "+termParmBldr.getId());
                continue; //skip
            }
            System.out.println("Term param: "+termParmBldr.getId());
            //termParmBldr.setId(null);
            //termParmBldr.setTermId(null);
            if (TermParameterTypes.COURSE_CLUSET_KEY.getId().equals(termParmBldr.getName()) || TermParameterTypes.PROGRAM_CLUSET_KEY.getId().equals(termParmBldr.getName()) || TermParameterTypes.CLUSET_KEY.getId().equals(termParmBldr.getName())) {
                try {
                    System.out.println("CluSet before: "+termParmBldr.getValue());
                    //get the cluSet to check if its an ad-hoc set
                    CluSetInfo cluSet = cluService.getCluSet(termParmBldr.getValue(), contextInfo);
                    //if not reusable, create a copy of the set and use that id in the term parameter value.
                    if (!cluSet.getIsReusable()) {
                        cluSet.setId(null);
                        //Clear clu ids if membership info exists, they will be re-added based on membership info
                        if (cluSet.getMembershipQuery() != null) {
                            cluSet.getCluIds().clear();
                            cluSet.getCluSetIds().clear();
                        }

                        cluSet = cluService.createCluSet(cluSet.getTypeKey(), cluSet, contextInfo);
                        System.out.println("CREATE CluSet: "+cluSet.getId());
                        termParmBldr.setValue(cluSet.getId());
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }

            }
            System.out.println("CluSet after: "+termParmBldr.getValue());
            System.out.println("UPDATE Term param: "+termParmBldr.getId() + " to " + termParmBldr.getValue());
        }
        //save the term with the updated params
        termRepositoryService.updateTerm(termBldr.build());
    }

    private void addToCluSetMap(String cluSetId, TermTermParamInfo info) {
        if (cluSetMap.containsKey(cluSetId)) {
            cluSetMap.get(cluSetId).add(info);
        } else {
            List<TermTermParamInfo> newList = new ArrayList<TermTermParamInfo>();
            newList.add(info);
            cluSetMap.put(cluSetId, newList);
        }
    }

    private void populateCluSetMap() {
        //addToCluSetMap("cluSetId", new TermTermParamInfo("termId", "termParamId"));
        addToCluSetMap("0cab1671-b09b-4a9f-99a5-3ddf57361392", new TermTermParamInfo("12295","12301"));
        addToCluSetMap("3e7aa9f0-6fed-42dc-81bb-435a69f7b2ce", new TermTermParamInfo("12309","12315"));
        addToCluSetMap("565d19a7-6fc5-45af-80ff-5ff4d94365fa", new TermTermParamInfo("12314","12321"));
        addToCluSetMap("416bb4d4-3b60-4d52-a1f9-b1f04dcdaa5d", new TermTermParamInfo("12315","12323"));
        addToCluSetMap("8e62f8f7-dc9c-4d43-a7ba-39fb431e3a50", new TermTermParamInfo("12319","12327"));
        addToCluSetMap("d8478c18-b99e-4e05-ac2a-a5623ed506fb", new TermTermParamInfo("12321","12330"));
        addToCluSetMap("279b36e8-e0c9-4524-906d-0b61e35e6db1", new TermTermParamInfo("12323","12332"));
        addToCluSetMap("42d6c8d8-a27b-4aa3-92fa-b06f9524b39b", new TermTermParamInfo("12326","12335"));
        addToCluSetMap("f9b1d3a9-ad34-4d2e-97cc-c45c4cd3eb89", new TermTermParamInfo("12341","12350"));
        addToCluSetMap("14cc4043-f0cc-44fb-8c40-40cd4372cd10", new TermTermParamInfo("12342","12352"));
        addToCluSetMap("1449eb03-8808-4dd6-9367-65d643654bb9", new TermTermParamInfo("12344","12354"));
        addToCluSetMap("b009038d-b950-4009-ab44-41d88afe661b", new TermTermParamInfo("12345","12355"));
        addToCluSetMap("fdf33c1d-63d2-4d2d-bd54-7881bd84eb98", new TermTermParamInfo("12348","12359"));
        addToCluSetMap("84c94710-5381-45a6-807a-f83f2fff54ec", new TermTermParamInfo("12349","12361"));
        addToCluSetMap("cb23862a-f8c0-486b-9902-8fb23d5bc9a6", new TermTermParamInfo("12350","12363"));
        addToCluSetMap("27b5b42d-c34f-46e9-bb27-cf2d403322f2", new TermTermParamInfo("12351","12365"));
        addToCluSetMap("cbd0f58f-26e6-4c23-86f6-25493fc69115", new TermTermParamInfo("12352","12366"));
        addToCluSetMap("fc61a323-4432-4c0d-be2d-e480524462d4", new TermTermParamInfo("12359","12373"));
        addToCluSetMap("8ca2b049-8567-4f0d-85ca-9a65cb7b5d90", new TermTermParamInfo("12360","12374"));
        addToCluSetMap("c3faace1-a86e-4ba0-a1fd-b18bd8a0fc95", new TermTermParamInfo("12477","12491"));
        addToCluSetMap("9562ba90-ff79-40db-baf9-3a384d79eeb3", new TermTermParamInfo("12526","12540"));
        addToCluSetMap("6a314b5d-9c2f-470a-9c9b-0e870e59c0d0", new TermTermParamInfo("12530","12544"));
        addToCluSetMap("a4a7cb46-9e39-4e9a-a091-f9ddc9382aad", new TermTermParamInfo("12535","12549"));
        addToCluSetMap("74de3880-624f-48cf-bf04-bd1ecfc6f204", new TermTermParamInfo("12537","12552"));
        addToCluSetMap("fa4fed31-cf28-4cd0-b125-3445e3302b94", new TermTermParamInfo("12538","12554"));
        addToCluSetMap("47649970-a003-4c45-9693-6679d93581ca", new TermTermParamInfo("12539","12556"));
        addToCluSetMap("2d600b2d-f455-4597-a6d5-b36cda421fe1", new TermTermParamInfo("12540","12558"));
        addToCluSetMap("f61fa77c-9a87-4db1-8d33-5b8bca4322be", new TermTermParamInfo("12546","12565"));
        addToCluSetMap("a6ad4f4c-b41f-4c91-b74f-6a714cbff75c", new TermTermParamInfo("12552","12571"));
        addToCluSetMap("fce381c8-55b8-41d3-9fcb-6f05b44ffff7", new TermTermParamInfo("12562","12581"));
        addToCluSetMap("e301bea7-0fad-459a-9447-b5432d50641c", new TermTermParamInfo("12569","12588"));
        addToCluSetMap("f42680f6-41de-4b94-b100-66e50baeb4cc", new TermTermParamInfo("12580","12599"));
        addToCluSetMap("c281a3be-3ffa-4a12-bf86-de6926179f22", new TermTermParamInfo("12589","12608"));
        addToCluSetMap("e77d9dc6-1296-41ed-9131-523bb54fb303", new TermTermParamInfo("12590","12609"));
        addToCluSetMap("e0cb859b-9000-47fd-a3cf-7fc9c24df367", new TermTermParamInfo("12591","12610"));
        addToCluSetMap("21b9f6f3-7d6c-422b-9d25-1e4ec113df4b", new TermTermParamInfo("12594","12613"));
        addToCluSetMap("dba98d72-c1dd-4096-8605-cf642a4f6774", new TermTermParamInfo("12600","12619"));
        addToCluSetMap("c08123af-3498-4f95-850d-16b3ed6fff25", new TermTermParamInfo("12602","12621"));
        addToCluSetMap("91bc807c-d76a-409c-83c0-695cb945075e", new TermTermParamInfo("12613","12633"));
        addToCluSetMap("e4f1a5b6-b35c-4a0e-8a6e-1326ceccbd6d", new TermTermParamInfo("12614","12635"));
        addToCluSetMap("cf6f1431-e918-489a-9893-35b5b4d36ff9", new TermTermParamInfo("12617","12638"));
        addToCluSetMap("3bd48ba5-2d6f-4d24-b335-2f482441e1f4", new TermTermParamInfo("12618","12639"));
        addToCluSetMap("f072ed5d-2a39-424d-bac4-f0081e1cf4bb", new TermTermParamInfo("12653","12674"));
        addToCluSetMap("b37b367b-aee3-4b88-b9a7-b84cccfa2c23", new TermTermParamInfo("12655","12676"));
        addToCluSetMap("6dc1a13e-d4b0-48a7-a166-0ee60e411295", new TermTermParamInfo("12670","12691"));
        addToCluSetMap("4ae90739-4013-447b-9a3a-1aececa2b964", new TermTermParamInfo("12671","12692"));
        addToCluSetMap("0513ec18-e77b-49df-a529-54aa12ee55ef", new TermTermParamInfo("12672","12693"));
        addToCluSetMap("e42ecc7e-4757-47fb-a1c6-d95a11068593", new TermTermParamInfo("12679","12700"));
        addToCluSetMap("0a9b633f-6aae-4877-991a-a86c997d09ea", new TermTermParamInfo("12687","12709"));
        addToCluSetMap("e4f1a5b6-b35c-4a0e-8a6e-1326ceccbd6d", new TermTermParamInfo("12689","12712"));
        addToCluSetMap("f8c72364-b0fd-4df1-962a-bf59f1dea54c", new TermTermParamInfo("12699","12722"));
        addToCluSetMap("c346f81b-7f14-4b9f-a23c-ed2029eec577", new TermTermParamInfo("12700","12723"));
        addToCluSetMap("e20fc6c5-c2e2-42db-a9ea-6d9b36460439", new TermTermParamInfo("12703","12726"));
        addToCluSetMap("dda31c9e-741a-430b-8991-1ff548f56c96", new TermTermParamInfo("12704","12727"));
        addToCluSetMap("a6d61113-871f-4552-9ea7-db3754305055", new TermTermParamInfo("12705","12728"));
        addToCluSetMap("e7648ef6-dd34-470a-aa6f-268484a16d5a", new TermTermParamInfo("12706","12729"));
        addToCluSetMap("32a6177a-993d-4c35-9eff-2b3177e452a4", new TermTermParamInfo("12708","12731"));
        addToCluSetMap("b95cb76d-857d-48fd-aece-44001ab364df", new TermTermParamInfo("12709","12732"));
        addToCluSetMap("e5d23049-37fc-450c-b4fa-5831ddcf012e", new TermTermParamInfo("12733","12757"));
        addToCluSetMap("2ad370f0-36a2-4487-9ad9-9050812535cb", new TermTermParamInfo("12737","12761"));
        addToCluSetMap("ee4b44d2-40fc-4402-a8ab-bc7247c5e67f", new TermTermParamInfo("12740","12764"));
        addToCluSetMap("e914f45e-d193-4a9d-abbf-a35d70d7cfd4", new TermTermParamInfo("12741","12765"));
        addToCluSetMap("3af50a5f-52e5-4e1b-b824-17a806d89786", new TermTermParamInfo("12742","12766"));
        addToCluSetMap("bf2a12c3-34a6-4721-9c2c-6b758f6bd7a3", new TermTermParamInfo("12743","12767"));
        addToCluSetMap("59bc13db-7ccc-4e78-a87b-c4fd2c023cda", new TermTermParamInfo("12745","12769"));
        addToCluSetMap("cbc17b3d-1a75-414a-8f3b-580a02360a2f", new TermTermParamInfo("12750","12774"));
        addToCluSetMap("d0944755-f24f-4ec9-9448-b2a37d120a38", new TermTermParamInfo("12758","12782"));
        addToCluSetMap("039dd9cc-d12e-458b-866f-e7684c490674", new TermTermParamInfo("12760","12785"));
        addToCluSetMap("e75cd462-f58d-422f-af6f-e65e8c6258a4", new TermTermParamInfo("12779","12804"));
        addToCluSetMap("dfec2eb3-ed91-4c7b-90f2-41f5f46815cc", new TermTermParamInfo("12784","12810"));
        addToCluSetMap("acff23e4-57df-4999-b491-2a6267a04a63", new TermTermParamInfo("12785","12812"));
        addToCluSetMap("f9ac7323-03bb-4aaf-ad8a-89c06ce4a1fc", new TermTermParamInfo("12790","12817"));
        addToCluSetMap("2353a482-3b81-4fb9-947a-9ee35c18d519", new TermTermParamInfo("12792","12819"));
        addToCluSetMap("192b03ad-075d-4a1d-84dd-774dec6e314e", new TermTermParamInfo("12798","12825"));
        addToCluSetMap("ed90e992-aa7d-4a72-abc2-4bfd0819211a", new TermTermParamInfo("12799","12826"));
        addToCluSetMap("31c363b8-9611-4c07-ae83-65061a65d701", new TermTermParamInfo("12800","12827"));
        addToCluSetMap("84f46372-b5a5-490c-81b1-3803be0713dc", new TermTermParamInfo("12802","12829"));
        addToCluSetMap("cb49c3bb-dad8-419a-b87e-fe7e1ece6036", new TermTermParamInfo("12810","12837"));
        addToCluSetMap("44f5dac3-9699-4f28-bf1b-51e3fd95a1c5", new TermTermParamInfo("12821","12841"));
        addToCluSetMap("65eedeae-d63a-4b21-a864-e247b786a150", new TermTermParamInfo("12823","12843"));
        addToCluSetMap("6300db00-4957-47c9-aef4-591bc114e015", new TermTermParamInfo("12824","12844"));
        addToCluSetMap("30db3d7c-e9b5-4c9e-b659-fd104e8b3be0", new TermTermParamInfo("12826","12846"));
        addToCluSetMap("1826fd1d-d382-472b-af96-cabba5440b10", new TermTermParamInfo("12828","12848"));
        addToCluSetMap("6ede31d9-259d-4697-9efa-13e54ec792b1", new TermTermParamInfo("12840","12860"));
        addToCluSetMap("75590bd4-7de2-4037-8a45-59323d2fdf72", new TermTermParamInfo("12849","12868"));
        addToCluSetMap("a3831cde-80ff-4209-8e3e-90d683546918", new TermTermParamInfo("12855","12873"));
        addToCluSetMap("fbf03658-4532-400b-b157-e4bbaa306c08", new TermTermParamInfo("12864","12882"));
        addToCluSetMap("01c9b77e-9aaa-4c3e-a6b5-a20db8ccc207", new TermTermParamInfo("12866","12884"));
        addToCluSetMap("da12e2f7-ebe0-4189-aff8-dd9e2aba2496", new TermTermParamInfo("12867","12885"));
        addToCluSetMap("08597942-b4f3-4a4f-a14e-e0ebfe2acb6b", new TermTermParamInfo("12869","12887"));
        addToCluSetMap("f5ba2fc1-4668-4a81-814b-9241057193ff", new TermTermParamInfo("12871","12889"));
        addToCluSetMap("a41ae744-0eb5-448e-b7e0-415755192ed4", new TermTermParamInfo("12873","12891"));
        addToCluSetMap("45111cce-0a10-451c-bd26-067d1a0d7d74", new TermTermParamInfo("12877","12895"));
        addToCluSetMap("8646c7b0-969e-4db7-8346-70ebbe9eafe7", new TermTermParamInfo("12878","12896"));
        addToCluSetMap("dcc6c79c-6fe1-4592-9396-d57f296cd990", new TermTermParamInfo("12882","12900"));
        addToCluSetMap("b7bfb2b0-760e-4004-8974-0cf437009ea9", new TermTermParamInfo("12888","12906"));
        addToCluSetMap("3272c717-61a7-4aac-8391-17c8b95a5881", new TermTermParamInfo("12889","12907"));
        addToCluSetMap("bb1bb583-e137-48a3-9b98-41f81cd08e9b", new TermTermParamInfo("12890","12908"));
        addToCluSetMap("066465ad-9b72-4f61-aa6d-9be4a772ec1a", new TermTermParamInfo("12891","12909"));
        addToCluSetMap("bf866d67-c34f-41c3-984d-4f64ad348632", new TermTermParamInfo("12892","12910"));
        addToCluSetMap("bb9a8011-4efa-425b-a0bc-a69a8f88ff8d", new TermTermParamInfo("12896","12914"));
        addToCluSetMap("2353a482-3b81-4fb9-947a-9ee35c18d519", new TermTermParamInfo("12918","12934"));
        addToCluSetMap("f9b1d3a9-ad34-4d2e-97cc-c45c4cd3eb89", new TermTermParamInfo("12923","12939"));
        addToCluSetMap("6a314b5d-9c2f-470a-9c9b-0e870e59c0d0", new TermTermParamInfo("12926","12942"));
        addToCluSetMap("e4f1a5b6-b35c-4a0e-8a6e-1326ceccbd6d", new TermTermParamInfo("12934","12951"));
        addToCluSetMap("e4f1a5b6-b35c-4a0e-8a6e-1326ceccbd6d", new TermTermParamInfo("12935","12953"));
        addToCluSetMap("da12e2f7-ebe0-4189-aff8-dd9e2aba2496", new TermTermParamInfo("12952","12970"));
        addToCluSetMap("c3faace1-a86e-4ba0-a1fd-b18bd8a0fc95", new TermTermParamInfo("12953","12971"));
        addToCluSetMap("44f5dac3-9699-4f28-bf1b-51e3fd95a1c5", new TermTermParamInfo("12954","12972"));
        addToCluSetMap("f072ed5d-2a39-424d-bac4-f0081e1cf4bb", new TermTermParamInfo("12958","12976"));
        addToCluSetMap("fbf03658-4532-400b-b157-e4bbaa306c08", new TermTermParamInfo("12962","12980"));
        addToCluSetMap("fbf03658-4532-400b-b157-e4bbaa306c08", new TermTermParamInfo("12964","12982"));
        addToCluSetMap("fbf03658-4532-400b-b157-e4bbaa306c08", new TermTermParamInfo("12966","12984"));
        addToCluSetMap("cb23862a-f8c0-486b-9902-8fb23d5bc9a6", new TermTermParamInfo("12969","12988"));
        addToCluSetMap("27b5b42d-c34f-46e9-bb27-cf2d403322f2", new TermTermParamInfo("12970","12990"));
        addToCluSetMap("31c363b8-9611-4c07-ae83-65061a65d701", new TermTermParamInfo("12971","12991"));
        addToCluSetMap("e7648ef6-dd34-470a-aa6f-268484a16d5a", new TermTermParamInfo("12979","12997"));
        addToCluSetMap("d8478c18-b99e-4e05-ac2a-a5623ed506fb", new TermTermParamInfo("12994","13013"));
        addToCluSetMap("f9ac7323-03bb-4aaf-ad8a-89c06ce4a1fc", new TermTermParamInfo("12996","13015"));
        addToCluSetMap("6dc1a13e-d4b0-48a7-a166-0ee60e411295", new TermTermParamInfo("13008","13027"));
        addToCluSetMap("6dc1a13e-d4b0-48a7-a166-0ee60e411295", new TermTermParamInfo("13012","13031"));
        addToCluSetMap("a3831cde-80ff-4209-8e3e-90d683546918", new TermTermParamInfo("13014","13033"));
        addToCluSetMap("1826fd1d-d382-472b-af96-cabba5440b10", new TermTermParamInfo("13016","13035"));
        addToCluSetMap("0cab1671-b09b-4a9f-99a5-3ddf57361392", new TermTermParamInfo("13022","13041"));
        addToCluSetMap("f61fa77c-9a87-4db1-8d33-5b8bca4322be", new TermTermParamInfo("13023","13043"));
        addToCluSetMap("cbc17b3d-1a75-414a-8f3b-580a02360a2f", new TermTermParamInfo("13027","13047"));
        addToCluSetMap("cbc17b3d-1a75-414a-8f3b-580a02360a2f", new TermTermParamInfo("13030","13050"));
        addToCluSetMap("14cc4043-f0cc-44fb-8c40-40cd4372cd10", new TermTermParamInfo("13035","13056"));
        addToCluSetMap("192b03ad-075d-4a1d-84dd-774dec6e314e", new TermTermParamInfo("13036","13057"));
        addToCluSetMap("cf6f1431-e918-489a-9893-35b5b4d36ff9", new TermTermParamInfo("13045","13066"));
        addToCluSetMap("f8c72364-b0fd-4df1-962a-bf59f1dea54c", new TermTermParamInfo("13046","13067"));
        addToCluSetMap("b95cb76d-857d-48fd-aece-44001ab364df", new TermTermParamInfo("13047","13068"));
        addToCluSetMap("f42680f6-41de-4b94-b100-66e50baeb4cc", new TermTermParamInfo("13098","13114"));
        addToCluSetMap("9562ba90-ff79-40db-baf9-3a384d79eeb3", new TermTermParamInfo("13114","13130"));
        addToCluSetMap("e42ecc7e-4757-47fb-a1c6-d95a11068593", new TermTermParamInfo("13120","13136"));
        addToCluSetMap("dba98d72-c1dd-4096-8605-cf642a4f6774", new TermTermParamInfo("13122","13138"));
        addToCluSetMap("e20fc6c5-c2e2-42db-a9ea-6d9b36460439", new TermTermParamInfo("13124","13140"));
        addToCluSetMap("a4a7cb46-9e39-4e9a-a091-f9ddc9382aad", new TermTermParamInfo("13131","13147"));
        addToCluSetMap("279b36e8-e0c9-4524-906d-0b61e35e6db1", new TermTermParamInfo("13152","13168"));
        addToCluSetMap("cb49c3bb-dad8-419a-b87e-fe7e1ece6036", new TermTermParamInfo("13181","13197"));
        addToCluSetMap("3e7aa9f0-6fed-42dc-81bb-435a69f7b2ce", new TermTermParamInfo("13192","13208"));
        addToCluSetMap("a6d61113-871f-4552-9ea7-db3754305055", new TermTermParamInfo("13193","13209"));
        addToCluSetMap("3e7aa9f0-6fed-42dc-81bb-435a69f7b2ce", new TermTermParamInfo("13194","13210"));
        addToCluSetMap("a6d61113-871f-4552-9ea7-db3754305055", new TermTermParamInfo("13195","13211"));
        addToCluSetMap("ee4b44d2-40fc-4402-a8ab-bc7247c5e67f", new TermTermParamInfo("13196","13212"));
        addToCluSetMap("2ad370f0-36a2-4487-9ad9-9050812535cb", new TermTermParamInfo("13210","13226"));
        addToCluSetMap("b009038d-b950-4009-ab44-41d88afe661b", new TermTermParamInfo("13214","13230"));
        addToCluSetMap("e5d23049-37fc-450c-b4fa-5831ddcf012e", new TermTermParamInfo("13223","13240"));
        addToCluSetMap("e301bea7-0fad-459a-9447-b5432d50641c", new TermTermParamInfo("13226","13243"));
        addToCluSetMap("21b9f6f3-7d6c-422b-9d25-1e4ec113df4b", new TermTermParamInfo("13232","13249"));
        addToCluSetMap("c346f81b-7f14-4b9f-a23c-ed2029eec577", new TermTermParamInfo("13234","13251"));
        addToCluSetMap("fce381c8-55b8-41d3-9fcb-6f05b44ffff7", new TermTermParamInfo("13236","13253"));
        addToCluSetMap("32a6177a-993d-4c35-9eff-2b3177e452a4", new TermTermParamInfo("13266","13282"));
        addToCluSetMap("0513ec18-e77b-49df-a529-54aa12ee55ef", new TermTermParamInfo("13271","13287"));
        addToCluSetMap("e914f45e-d193-4a9d-abbf-a35d70d7cfd4", new TermTermParamInfo("13272","13288"));
        addToCluSetMap("3af50a5f-52e5-4e1b-b824-17a806d89786", new TermTermParamInfo("13273","13289"));
        addToCluSetMap("08597942-b4f3-4a4f-a14e-e0ebfe2acb6b", new TermTermParamInfo("13277","13293"));
        addToCluSetMap("08597942-b4f3-4a4f-a14e-e0ebfe2acb6b", new TermTermParamInfo("13278","13294"));
        addToCluSetMap("08597942-b4f3-4a4f-a14e-e0ebfe2acb6b", new TermTermParamInfo("13279","13295"));
        addToCluSetMap("08597942-b4f3-4a4f-a14e-e0ebfe2acb6b", new TermTermParamInfo("13280","13296"));
        addToCluSetMap("08597942-b4f3-4a4f-a14e-e0ebfe2acb6b", new TermTermParamInfo("13281","13297"));
        addToCluSetMap("e0cb859b-9000-47fd-a3cf-7fc9c24df367", new TermTermParamInfo("13284","13300"));
        addToCluSetMap("039dd9cc-d12e-458b-866f-e7684c490674", new TermTermParamInfo("13287","13304"));
        addToCluSetMap("fc61a323-4432-4c0d-be2d-e480524462d4", new TermTermParamInfo("13302","13319"));
        addToCluSetMap("01c9b77e-9aaa-4c3e-a6b5-a20db8ccc207", new TermTermParamInfo("13310","13327"));
        addToCluSetMap("74de3880-624f-48cf-bf04-bd1ecfc6f204", new TermTermParamInfo("13329","13347"));
        addToCluSetMap("fa4fed31-cf28-4cd0-b125-3445e3302b94", new TermTermParamInfo("13330","13349"));
        addToCluSetMap("47649970-a003-4c45-9693-6679d93581ca", new TermTermParamInfo("13331","13351"));
        addToCluSetMap("45111cce-0a10-451c-bd26-067d1a0d7d74", new TermTermParamInfo("13334","13354"));
        addToCluSetMap("c08123af-3498-4f95-850d-16b3ed6fff25", new TermTermParamInfo("13335","13355"));
        addToCluSetMap("4ae90739-4013-447b-9a3a-1aececa2b964", new TermTermParamInfo("13340","13360"));
        addToCluSetMap("4ae90739-4013-447b-9a3a-1aececa2b964", new TermTermParamInfo("13342","13362"));
        addToCluSetMap("75590bd4-7de2-4037-8a45-59323d2fdf72", new TermTermParamInfo("13346","13366"));
        addToCluSetMap("65eedeae-d63a-4b21-a864-e247b786a150", new TermTermParamInfo("13350","13370"));
        addToCluSetMap("6300db00-4957-47c9-aef4-591bc114e015", new TermTermParamInfo("13351","13371"));
        addToCluSetMap("a6ad4f4c-b41f-4c91-b74f-6a714cbff75c", new TermTermParamInfo("13359","13379"));
        addToCluSetMap("dcc6c79c-6fe1-4592-9396-d57f296cd990", new TermTermParamInfo("13361","13381"));
        addToCluSetMap("dcc6c79c-6fe1-4592-9396-d57f296cd990", new TermTermParamInfo("13362","13382"));
        addToCluSetMap("dcc6c79c-6fe1-4592-9396-d57f296cd990", new TermTermParamInfo("13363","13383"));
        addToCluSetMap("dcc6c79c-6fe1-4592-9396-d57f296cd990", new TermTermParamInfo("13364","13384"));
        addToCluSetMap("dcc6c79c-6fe1-4592-9396-d57f296cd990", new TermTermParamInfo("13365","13385"));
        addToCluSetMap("dcc6c79c-6fe1-4592-9396-d57f296cd990", new TermTermParamInfo("13366","13386"));
        addToCluSetMap("dcc6c79c-6fe1-4592-9396-d57f296cd990", new TermTermParamInfo("13367","13387"));
        addToCluSetMap("dcc6c79c-6fe1-4592-9396-d57f296cd990", new TermTermParamInfo("13368","13388"));
        addToCluSetMap("3bd48ba5-2d6f-4d24-b335-2f482441e1f4", new TermTermParamInfo("13369","13389"));
        addToCluSetMap("bb9a8011-4efa-425b-a0bc-a69a8f88ff8d", new TermTermParamInfo("13418","13430"));

    }


}
