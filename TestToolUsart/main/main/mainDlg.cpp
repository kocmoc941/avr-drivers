#include "stdafx.h"
#include "main.h"
#include "mainDlg.h"
#include "afxdialogex.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#endif

MainDialog::MainDialog(UINT nIDTemplate, CWnd* pParentWnd)
    : CDialogEx(nIDTemplate, pParentWnd)
{
}

void MainDialog::OnAdd()
{
}

void MainDialog::DoDataExchange(CDataExchange *cDx) 
{
    //DDX_Text(cDx, IDC_STATIC, m_text);
}

BOOL MainDialog::PreTranslateMessage(MSG* pMsg)
{
    return FALSE;
}

void MainDialog::addText(CString &str)
{
    m_text += str;
}

BEGIN_MESSAGE_MAP(MainDialog, CDialog)
    ON_BN_CLICKED(IDC_BUTTON1, OnAdd)
END_MESSAGE_MAP()