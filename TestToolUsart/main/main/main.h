#pragma once

#ifndef __AFXWIN_H__
	#error "include 'stdafx.h' before including this file for PCH"
#endif

#include "resource.h"

class CmainApp : public CWinApp
{
public:
	CmainApp();

public:
	virtual BOOL InitInstance();

	DECLARE_MESSAGE_MAP()
    CDialog *m_dlg;
};

extern CmainApp theApp;
