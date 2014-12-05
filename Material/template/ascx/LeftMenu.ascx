<%@ Control Language="C#" AutoEventWireup="true" CodeFile="LeftMenu.ascx.cs" Inherits="LeftMenu" %>
<style>
  .submenu li{ font-size:12px;}
</style>
<div class="sidebar" id="sidebar">

					<script type="text/javascript">
					    try {					        
                            ace.settings.check('sidebar', 'fixed');
                            
                        } catch (e) { }
					</script>

					<div class="sidebar-shortcuts" id="sidebar-shortcuts">
						<div class="sidebar-shortcuts-large" id="sidebar-shortcuts-large">
							<button class="btn btn-success">
								<i class="icon-signal"></i>
							</button>

							<button class="btn btn-info">
								<i class="icon-pencil"></i>
							</button>

							<button class="btn btn-warning">
								<i class="icon-group"></i>
							</button>

							<button class="btn btn-danger">
								<i class="icon-cogs"></i>
							</button>
						</div>

						<div class="sidebar-shortcuts-mini" id="sidebar-shortcuts-mini">
							<span class="btn btn-success"></span>

							<span class="btn btn-info"></span>

							<span class="btn btn-warning"></span>

							<span class="btn btn-danger"></span>
						</div>
					</div><!-- #sidebar-shortcuts -->

					<ul class="nav nav-list">
						<li >
							<a href="#">
								<i class="icon-dashboard"></i>
								<span class="menu-text"> 控制台 </span>
							</a>
						</li>						
						<li class="active" id="cItem01">
							<a href="#" class="dropdown-toggle call">
								<i class="icon-desktop"></i>
								<span class="menu-text"> 基本設定作業 </span>

								<b class="arrow icon-angle-down"></b>
							</a>

							<ul class="submenu">
								<li style="display:none;">
									<a href="<%= ResolveUrl("~/SiteFunction/A10.aspx") %>">
										<i class="icon-double-angle-right"></i>
										帳號管理
									</a>
								</li>

								<li style="display:none;">
									<a href="<%= ResolveUrl("~/SiteFunction/A11.aspx") %>">
										<i class="icon-double-angle-right"></i>
										群組管理
									</a>
								</li>

								<li>
									<a href="<%= ResolveUrl("~/SiteFunction/A12.aspx") %>">
										<i class="icon-double-angle-right"></i>
										廠商管理
									</a>
								</li>

								<li>
									<a href="<%= ResolveUrl("~/SiteFunction/A13.aspx") %>">
										<i class="icon-double-angle-right"></i>
										客戶管理
									</a>
								</li>

								<li>
									<a href="<%= ResolveUrl("~/SiteFunction/A19.aspx") %>">
										<i class="icon-double-angle-right"></i>
										貨倉管理
									</a>
								</li>
                                <li>
									<a href="<%= ResolveUrl("~/SiteFunction/A20.aspx") %>">
										<i class="icon-double-angle-right"></i>
										聯絡人管理
									</a>
								</li>    
							</ul>
						</li>                        
						<li class="active" id="cItem02">
							<a href="#" class="dropdown-toggle">
								<i class="icon-list"></i>
								<span class="menu-text"> 物料資料管理 </span>

								<b class="arrow icon-angle-down"></b>
							</a>

							<ul class="submenu">
								<li style="display:none;">
									<a href="<%= ResolveUrl("~/SiteFunction/A30.aspx") %>">
										<i class="icon-double-angle-right"></i>
										品項分類管理
									</a>
								</li>

								<li>
									<a href="<%= ResolveUrl("~/SiteFunction/A31.aspx") %>">
										<i class="icon-double-angle-right"></i>
										品項資料管理
									</a>
								</li>                                
							</ul>
						</li>	
                        <li class="active" id="cItem03">
							<a href="#" class="dropdown-toggle">
								<i class="icon-list"></i>
								<span class="menu-text"> Local物料管理 </span>

								<b class="arrow icon-angle-down"></b>
							</a>
							<ul class="submenu">
								<li>
									<a href="<%= ResolveUrl("~/SiteFunction/A601L.aspx") %>">
										<i class="icon-double-angle-right"></i>
										訂單採購作業
									</a>
								</li>
                                <li>
									<a href="<%= ResolveUrl("~/SiteFunction/A602L.aspx") %>">
										<i class="icon-double-angle-right"></i>
										入料作業
									</a>
								</li>
								<li>
									<a href="<%= ResolveUrl("~/SiteFunction/A603L.aspx") %>">
										<i class="icon-double-angle-right"></i>
										出料作業
									</a>
								</li>
                                <li>
									<a href="<%= ResolveUrl("~/SiteFunction/A608L.aspx") %>">
										<i class="icon-double-angle-right"></i>
										到貨數量異常處理
									</a>
								</li>
                                <li>
									<a href="<%= ResolveUrl("~/SiteFunction/A606L.aspx") %>">
										<i class="icon-double-angle-right"></i>
										貨倉調播作業
									</a>
								</li>
                                <li>
									<a href="<%= ResolveUrl("~/SiteFunction/A607CL.aspx") %>">
										<i class="icon-double-angle-right"></i>
										承包商調播確認
									</a>
								</li>
                                <li>
									<a href="<%= ResolveUrl("~/SiteFunction/A611L.aspx") %>">
										<i class="icon-double-angle-right"></i>
										庫存報表
									</a>
								</li>
							</ul>
						</li>		
                        <li class="active" id="cItem04">
							<a href="#" class="dropdown-toggle">
								<i class="icon-list"></i>
								<span class="menu-text"> Global物料管理 </span>

								<b class="arrow icon-angle-down"></b>
							</a>
							<ul class="submenu">
								<li>
									<a href="<%= ResolveUrl("~/SiteFunction/A601G.aspx") %>">
										<i class="icon-double-angle-right"></i>
										訂單採購作業
									</a>
								</li>   
                                <li>
									<a href="<%= ResolveUrl("~/SiteFunction/A602G.aspx") %>">
										<i class="icon-double-angle-right"></i>
										入料作業
									</a>
								</li>   
                                <li>
									<a href="<%= ResolveUrl("~/SiteFunction/A603G.aspx") %>">
										<i class="icon-double-angle-right"></i>
										出料作業
									</a>
								</li>
                                <li style="display:none;">
									<a href="<%= ResolveUrl("~/SiteFunction/A608L.aspx") %>">
										<i class="icon-double-angle-right"></i>
										到貨數量異常處理
									</a>
								</li>
                                <li style="display:none;">
									<a href="<%= ResolveUrl("~/SiteFunction/A606G.aspx") %>">
										<i class="icon-double-angle-right"></i>
										貨倉調播作業
									</a>
								</li>    
                                <li style="display:none;">
									<a href="<%= ResolveUrl("~/SiteFunction/A607CG.aspx") %>">
										<i class="icon-double-angle-right"></i>
										承包商調播確認
									</a>
								</li>          
                                <li>
									<a href="<%= ResolveUrl("~/SiteFunction/A611G.aspx") %>">
										<i class="icon-double-angle-right"></i>
										庫存報表
									</a>
								</li>            
							</ul>
						</li>		
                        <li class="active" id="cItem05">
							<a href="#" class="dropdown-toggle">
								<i class="icon-list"></i>
								<span class="menu-text"> 承包商物料管理 </span>

								<b class="arrow icon-angle-down"></b>
							</a>
                            <ul class="submenu">
								<li>
									<a href="<%= ResolveUrl("~/SiteFunction/A604L.aspx") %>">
										<i class="icon-double-angle-right"></i>
										到料查詢
									</a>
								</li>	
                                <li>
									<a href="<%= ResolveUrl("~/SiteFunction/A605L.aspx") %>">
										<i class="icon-double-angle-right"></i>
										到貨作業
									</a>
								</li>
                                <li>
									<a href="<%= ResolveUrl("~/SiteFunction/A607L.aspx") %>">
										<i class="icon-double-angle-right"></i>
										調播作業
									</a>
								</li>												
							</ul>                           
						</li>																					
					</ul><!-- /.nav-list -->

					<div class="sidebar-collapse" id="sidebar-collapse">
						<i class="icon-double-angle-left" data-icon1="icon-double-angle-left" data-icon2="icon-double-angle-right"></i>
					</div>

					<script type="text/javascript">


					    try { ace.settings.check('sidebar', 'collapsed') } catch (e) { }
					    

					</script>                    
                    
                <script type="text/javascript">

                    var pUrl = "<%=PageName%>";
                    var OpenTag = "";
                    if (pUrl == "A601L" || pUrl == "A602L" || pUrl == "A603L" || pUrl == "A608L" || pUrl == "A606L" || pUrl == "A607CL" || pUrl == "A611L") {

                        OpenTag = "cItem03";
        
                    }else if (pUrl == "A601G" || pUrl == "A602G" || pUrl == "A603G" || pUrl == "A608G" || pUrl == "A606G" || pUrl == "A607CG") {

                        OpenTag = "cItem04";

                    } else if (pUrl == "A604L" || pUrl == "A605L" || pUrl == "A607L" ) {

                        OpenTag = "cItem05";
                    } else if (pUrl == "A631" ) {

                        OpenTag = "cItem02";

                    } else {
                        OpenTag = "cItem01";
        
                    }

                    $(".active").each(function (index) {
                        if (this.id == OpenTag) {
                        } else {
                            $(this).removeClass("active");
                        }                
                    });

                </script>
		</div>                 