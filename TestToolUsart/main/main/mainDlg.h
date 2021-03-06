#pragma once

#include "afxwin.h"
#include <thread>

class MainDialog : public CDialogEx
{
public:
    explicit MainDialog(UINT nIDTemplate, CWnd* pParentWnd = NULL);

protected:

    DECLARE_MESSAGE_MAP()

    afx_msg void DoDataExchange(CDataExchange *cDx);
    afx_msg BOOL PreTranslateMessage(MSG *pMsg);
    afx_msg BOOL OnInitDialog();
    void openPort();

private:
    void thread();

    std::thread m_thr;
    CEdit m_log;
    CEdit m_port;
    CButton m_openButton;
    HANDLE m_portHandle;
    BOOL m_connected = FALSE;
};
