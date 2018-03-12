#pragma once

#include "afxwin.h"

class MainDialog : public CDialogEx
{
public:
    explicit MainDialog(UINT nIDTemplate, CWnd* pParentWnd = NULL);

protected:

    DECLARE_MESSAGE_MAP()

    afx_msg void OnAdd();
    afx_msg void DoDataExchange(CDataExchange *cDx);
    afx_msg BOOL PreTranslateMessage(MSG *pMsg);
    void addText(CString &str);

private:
    CString m_text = L"";
    CStatic m_static;
};