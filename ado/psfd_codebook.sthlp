{smcl}
{* *! version 3.2.2  02sept2023}{...}
{viewerjumpto "Caution" "psfd_codebook##caution"}{...}
{viewerjumpto "Syntax" "psfd_codebook##syntax"}{...}
{viewerjumpto "Description" "psfd_codebook##description"}{...}
{viewerjumpto "Examples" "psfd_codebook##examples"}{...}
{viewerjumpto "Author and" "psfd_codebook##author"}{...}
{p2colset 1 18 1 25}{...}
{p2col:{cmd:psfd_codebook} {hline 2}} 製作「家庭動態調查」的編碼簿 {p_end}
{p2colreset}{...}

{synoptset 20 tabbed}{...}

{marker caution}{...}
{title:Caution}
{synoptset 10 tabbed}
{pstd}{cmd: 在使用此函式前，請務必先行{it:{help strings: cd}} 指定資料路徑。整併完成的編碼簿，將會儲存在該路徑下一個名為"documents"的資料夾中} {p_end}
{...}

{synoptset 20 tabbed}
{...}

{marker syntax}{...}
{title:Syntax}

{p 8 17 2}{cmd:psfd_codebook} {it:{help strings:varlist}} [ | 
    {it:{help strings:varlist}}]

{synopthdr}
{synoptline}
{synopt:{opt " | "}}在編碼簿中將製作一段「變項區段」。而被區隔出來的變項將會獨立製作成一個表格{p_end}
{synoptline}
{p2colreset}{...}
	

{marker description}{...}
{title:Description}

{pstd}
透過 {cmd: psfd_codebook} 此函式，可以讀取dta資料檔中的值標籤（value labels），並製作家庭動態調查（PSFD）樣式的編碼簿。{...}


{marker examples}{...}
{title:Examples}

{pstd}步驟一：建立本地端的資料檔存取路徑{p_end}
{phang2}{cmd:. cd d:\psfd\data}{p_end}

{pstd}步驟二：開啟資料檔，並執行函式{p_end}
{phang2}{cmd:. use RR2022.dta}{p_end}
{phang2}{cmd:. psfd_codebook a01 - d71}{p_end}

{pstd}可依據變項不同，將所區分出的變項，分別呈現在編碼簿的不同表格中 {p_end}
{phang2}{cmd:. psfd_codebook a01 - a02z02 | b01 - b04 | c02r1 - c49} {p_end}


{marker author}{...}
{title:Author}

{phang} {cmd: Tamao} (Academia Sinica, Taiwan) 
{...}
{pstd} 如發現程式上的漏洞或任何需要改進之處，均歡迎來信 <tamao@.gate.sinica.edu.tw>
{...}