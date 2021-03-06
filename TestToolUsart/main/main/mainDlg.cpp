#include "stdafx.h"
#include "main.h"
#include "mainDlg.h"
#include "afxdialogex.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#endif

static void AFXTRACE(BOOL res)
{
    if (!res) {
        LPVOID lpMsgBuf;
        DWORD dw = GetLastError();

        FormatMessageW(
            FORMAT_MESSAGE_ALLOCATE_BUFFER |
            FORMAT_MESSAGE_FROM_SYSTEM |
            FORMAT_MESSAGE_IGNORE_INSERTS,
            NULL,
            dw,
            MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT),
            (LPTSTR)&lpMsgBuf,
            0,
            NULL);
        AfxMessageBox((wchar_t *)lpMsgBuf);
        LocalFree(lpMsgBuf);
        ExitProcess(dw);
    }
}

MainDialog::MainDialog(UINT nIDTemplate, CWnd* pParentWnd)
    : CDialogEx(nIDTemplate, pParentWnd)
{
}

void MainDialog::DoDataExchange(CDataExchange *cDx) 
{
    DDX_Control(cDx, IDC_OPEN_PORT, m_openButton);
    DDX_Control(cDx, IDC_PORT, m_port);
    DDX_Control(cDx, IDC_LOG, m_log);
}

BOOL MainDialog::PreTranslateMessage(MSG* pMsg)
{
    return FALSE;
}

BOOL MainDialog::OnInitDialog()
{
    BOOL flag = CDialog::OnInitDialog();
    m_port.SetWindowTextW(L"COM3");
    return flag;
}

void MainDialog::thread()
{
    m_log.SetWindowTextW(_T("wait data..."));

    char buf[128];
    DWORD readed = 0;
    while (m_connected) {
        if (!ReadFile(m_portHandle, &buf, 1, &readed, nullptr))
            ASSERT(L"read file error");
        if (readed > 0)
            m_log.SetWindowTextW(CString(buf));
    }
    return;
    OVERLAPPED ov;
    memset(&ov, 0, sizeof(ov));
    ov.hEvent = CreateEvent(0, true, 0, 0);
    HANDLE arHandles[2];
    arHandles[0] = m_portHandle;
    DWORD dwWait;
    DWORD mask = 0x0;
    SetEvent(arHandles[0]);
    while (m_connected)
    {
        BOOL abRet = ::WaitCommEvent(arHandles[0], &mask, &ov);
        if (!abRet)
        {
            ASSERT(GetLastError() == ERROR_IO_PENDING);
        }
        arHandles[1] = ov.hEvent;
        dwWait = WaitForMultipleObjects(1, arHandles, FALSE, INFINITE);
        switch (dwWait)
        {
            case WAIT_OBJECT_0:
            {
                _endthreadex(1);
            }
            break;
            case WAIT_OBJECT_0 + 1:
            {
                DWORD dwMask;
                if (GetCommMask(arHandles[0], &dwMask))
                {
                    if (dwMask & EV_TXEMPTY)
                        TRACE("Data sent");
                    ResetEvent(ov.hEvent);
                    continue;
                }
                else
                {
                    //read data here and reset ov.hEvent
                }
            }
        }     //switch
    }       //while
}

void MainDialog::openPort()
{
    CString port;
    m_port.GetWindowTextW(port);
    port = L"\\\\.\\" + port;
    if (!m_connected) {
        m_portHandle = CreateFileW(  port,
                                     GENERIC_READ | GENERIC_WRITE,
                                     FILE_SHARE_READ,
                                     nullptr,
                                     OPEN_EXISTING,
                                     FILE_FLAG_OVERLAPPED,
                                     nullptr);
        m_openButton.SetWindowTextW(L"Close port");
    
        DCB dcb{};
        dcb.DCBlength = sizeof(dcb);

        AFXTRACE(GetCommState(m_portHandle, &dcb));
        dcb.BaudRate = BAUD_9600;
        dcb.ByteSize = 8;
        dcb.Parity = 0;
        dcb.StopBits = ONESTOPBIT;

        AFXTRACE(SetCommState(m_portHandle, &dcb));
        m_connected = TRUE;

        m_thr = std::thread(&MainDialog::thread, this);
        m_thr.detach();
    }
    else {
        m_openButton.SetWindowTextW(L"Open port");
        m_log.SetWindowTextW(nullptr);

        CloseHandle(m_portHandle);
        m_connected = FALSE;
    }
}

BEGIN_MESSAGE_MAP(MainDialog, CDialog)
    ON_BN_CLICKED(IDC_OPEN_PORT, openPort)
END_MESSAGE_MAP()
