#include "stdafx.h"
#include "main.h"
#include "mainDlg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#endif

BEGIN_MESSAGE_MAP(CmainApp, CWinApp)
END_MESSAGE_MAP()

CmainApp::CmainApp()
{}

CmainApp theApp;

BOOL CmainApp::InitInstance()
{
	CWinApp::InitInstance();

	CMFCVisualManager::SetDefaultManager(RUNTIME_CLASS(CMFCVisualManagerWindows));

	SetRegistryKey(_T("Local AppWizard-Generated Applications"));
    MainDialog cd(IDD_DIALOG1);
    m_pMainWnd = &cd;
    cd.DoModal();
 
	return TRUE;
}

