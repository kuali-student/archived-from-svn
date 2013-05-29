package org.kuali.student.loader.rules;

/**
 * Created with IntelliJ IDEA.
 * User: christoff
 * Date: 2013/05/22
 */
public class LuiInfoHelper {
    private String luiID;
    private String luiCode;
    private String atpCode;

    public LuiInfoHelper(String id, String code, String atp) {
        luiID = id;
        luiCode = code;
        atpCode = atp;
    }


    public String getLuiID() {
        return luiID;
    }

    public void setLuiID(String luiID) {
        this.luiID = luiID;
    }

    public String getLuiCode() {
        return luiCode;
    }

    public void setLuiCode(String luiCode) {
        this.luiCode = luiCode;
    }

    public String getAtpCode() {
        return atpCode;
    }

    public void setAtpCode(String atpCode) {
        this.atpCode = atpCode;
    }
}
