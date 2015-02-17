<%page expression_filter="h"/>
<%inherit file="project/project_base.mako"/>
<%def name="title()">${node['title'] | n} Wiki</%def>

<div class="row">
    <div class="col-xs-6">
        <%include file="wiki/templates/status.mako"/>
    </div>
    <div class="col-xs-6">
        <div class="pull-right">
          <div class="switch"></div>
          </div>
    </div>
</div>

<div class="wiki container">
  <div class="row wiki-wrapper">
    <div class="col-sm-3 panel-toggle">
        <div class="wiki-panel hidden-xs"> 
              <div class="wiki-panel-header"> <i class="icon-list"> </i>  Menu 
                <div class="pull-right"> <div class="panel-collapse"> <i class="icon icon-chevron-left"> </i> </div></div>
              </div>
              <div class="wiki-panel-body">
                <%include file="wiki/templates/nav.mako"/>
                <%include file="wiki/templates/toc.mako"/>
                </div>
            </div>
            <div class="wiki-panel visible-xs"> 
              <div class="wiki-panel-header"> <i class="icon-list"> </i>  Menu </div>
              <div class="wiki-panel-body ">
                <%include file="wiki/templates/nav.mako"/>
                <%include file="wiki/templates/toc.mako"/>
                </div>
            </div>

        <div class="wiki-panel panel-collapsed hidden-xs text-center" style="display: none;">
          <div class="wiki-panel-header">
            <i class="icon-list"> </i>
            <i class="icon icon-chevron-right"> </i>
          </div>
          <div class="wiki-panel-body">
              <%include file="wiki/templates/nav.mako"/>
           </div>
        </div>    
    </div>

    <div class="col-sm-9 panel-expand">
      <div class="row">

        % if can_edit:
        <div class="col-sm-4" data-osf-panel="Edit">
                <div class="wiki-panel"> 
                  <div class="wiki-panel-header"> <i class="icon-edit"> </i>  Edit </div>
                  <div class="wiki-panel-body"> 
                      <form id="wiki-form" action="${urls['web']['edit']}" method="POST">
                        <div class="row">
                        <div class="col-xs-12">
                          <div class="form-group wmd-panel">
                              <div class="row">
                                  <div class="col-sm-8">
                                       <p>
                                           <em>Changes will be stored but not published until
                                           you click "Save."</em>
                                       </p>
                                  </div>
                                  <div class="col-sm-4">
                                      <ul class="list-inline" data-bind="foreach: activeUsers" style="float: right">
                                          <!-- ko ifnot: id === '${user_id}' -->
                                              <li><a data-bind="attr: { href: url }" >
                                                  <img data-bind="attr: {src: gravatar}, tooltip: {title: name, placement: 'bottom'}"
                                                       style="border: 1px solid black;">
                                              </a></li>
                                          <!-- /ko -->
                                      </ul>
                                  </div>
                              </div>
                              <div id="wmd-button-bar"></div>
                              <div data-bind="fadeVisible: throttledStatus() !== 'connected'" class="scripted">
                                  <div class="progress" style="margin-bottom: 5px">
                                      <div role="progressbar"
                                           data-bind="attr: progressBar"
                                              >
                                          <span data-bind="text: statusDisplay"></span>
                                          <a class="sharejs-info-btn">
                                              <i class="icon-question-sign icon-large"
                                                 data-toggle="modal"
                                                 data-bind="attr: {data-target: modalTarget}"
                                                      >
                                              </i>
                                          </a>
                                      </div>
                                  </div>
                              </div>

                              <div id="editor" class="wmd-input wiki-editor"
                                   data-bind="ace: currentText">Loading. . .</div>
                          </div>
                        </div>
                      </div>
                      <div class="row">
                        <div class="col-xs-12">
                           <div class="pull-right">
                              <button id="revert-button"
                                      class="btn btn-success"
                                      data-bind="click: loadPublished"
                                      >Revert</button>
                              <input type="submit"
                                     class="btn btn-primary"
                                     value="Save"
                                     onclick=$(window).off('beforeunload')>
                          </div>
                        </div>
                      </div>
                        <!-- Invisible textarea for form submission -->
                        <textarea name="content" style="visibility: hidden; height: 0px"
                                  data-bind="value: currentText"></textarea>
                    </form>
                  </div>
                </div>
          </div>
          % endif
      
          <div class="col-sm-4" data-osf-panel="View">
              <div class="wiki-panel"> 
                <div class="wiki-panel-header">
                    <div class="row">
                        <div class="col-sm-6">
                            <i class="icon-eye-open"> </i>  View
                        </div>
                        <div class="col-sm-6">
                            <!-- Version Picker -->
                            <select id="viewVersionSelect" class="pull-right">
                                % if can_edit:
                                    <option value="preview">Preview</option>
                                % endif
                                <option value="current">Current</option>
                                % for version in versions[1:]:
                                    <option value="${version['version']}">Version ${version['version']}</option>
                                % endfor
                            </select>
                        </div>
                    </div>
                </div>
                <div class="wiki-panel-body">
                    <!-- Live preview from editor -->
                    <div id="viewPreview" class="markdown-it-view">
                        <div id="markdown-it-preview" ></div>
                    </div>
                    <!-- Version view -->
                    <div id="viewVersion" class="markdown-it-view" style="display: none;">
                        % if not page and wiki_name != 'home':
                            <p><i>This wiki page does not currently exist.</i></p>
                        % else:
                            <div id="markdownItRender">${wiki_content | n}</div>
                        % endif
                    </div>
                </div>
              </div>
          </div>
          <div class="col-sm-4" data-osf-panel="Compare">
            <div class="wiki-panel">
              <div class="wiki-panel-header">
                  <div class="row">
                      <div class="col-sm-6">
                          <i class="icon-exchange"> </i>  Compare
                      </div>
                      <div class="col-sm-6">
                            <!-- Version Picker -->
                            <select id="compareVersionSelect" class="pull-right">
                                <option value="current">Current</option>
                                % for version in versions[1:]:
                                    <option value="${version['version']}">Version ${version['version']}</option>
                                % endfor
                            </select>
                      </div>
                  </div>
              </div>
              <div class="wiki-panel-body">
                <div class="row">
                    <div class="col-xs-12"> ... coming soon </div>
                </div>
              </div>
            </div>
          </div>
      </div><!-- end row -->
    </div>

  </div>
</div><!-- end wiki -->


<div class="modal fade" id="permissionsModal">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h3 class="modal-title">The permissions for this page have changed</h3>
      </div>
      <div class="modal-body">
        <p>Your browser should refresh shortly&hellip;</p>
      </div>
    </div>
  </div>
</div>

<div class="modal fade" id="renameModal">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h3 class="modal-title">The content of this wiki has been moved to a different page</h3>
      </div>
      <div class="modal-body">
        <p>Your browser should refresh shortly&hellip;</p>
      </div>
    </div>
  </div>
</div>

<div class="modal fade" id="deleteModal" tabindex="-1">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h3 class="modal-title">This wiki page has been deleted</h3>
      </div>
      <div class="modal-body">
        <p>Press OK to return to the project wiki home page.</p>
      </div>
      <div class="modal-footer">
          <button type="button" class="btn btn-primary" data-dismiss="modal">OK</button>
      </div>
    </div>
  </div>
</div>

<div class="modal fade" id="connectingModal" tabindex="-1">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h3 class="modal-title">Connecting to the collaborative wiki</h3>
      </div>
      <div class="modal-body">
        <p>
            This page is currently attempting to connect to the collaborative wiki. You may continue to make edits.
            <strong>Changes will not be saved until you press the "Save" button.</strong>
        </p>
      </div>
    </div>
  </div>
</div>

<div class="modal fade" id="disconnectedModal" tabindex="-1">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h3 class="modal-title">Collaborative wiki is unavailable</h3>
      </div>
      <div class="modal-body">
        <p>
            The collaborative wiki is currently unavailable. You may continue to make edits.
            <strong>Changes will not be saved until you press the "Save" button.</strong>
        </p>
      </div>
    </div>
  </div>
</div>

<div class="modal fade" id="unsupportedModal" tabindex="-1">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h3 class="modal-title">Browser unsupported</h3>
      </div>
      <div class="modal-body">
        <p>
            Your browser does not support collaborative editing. You may continue to make edits.
            <strong>Changes will not be saved until you press the "Save" button.</strong>
        </p>
      </div>
    </div>
  </div>
</div>

<%def name="javascript_bottom()">
<% import json %>
${parent.javascript_bottom()}
<script>

    var canEdit = ${json.dumps(can_edit)};

    var canEditPageName = canEdit && ${json.dumps(
        wiki_id and wiki_name != 'home'
    )};

    window.contextVars = window.contextVars || {};
    window.contextVars.wiki = {
        canEdit: canEdit,
        canEditPageName: canEditPageName,
        usePythonRender: ${json.dumps(use_python_render)},
        urls: {
            draft: '${urls['api']['draft']}',
            content: '${urls['api']['content']}',
            rename: '${urls['api']['rename']}',
            base: '${urls['web']['base']}',
            sharejs: '${sharejs_url}'
        },
        metadata: {
            registration: true,
            docId: '${sharejs_uuid}',
            userId: '${user_id}',
            userName: '${user_full_name}',
            userUrl: '${user_url}',
            userGravatar: '${urls['gravatar']}'.replace('&amp;', '&')
        }
    };
</script>
<script src="//${sharejs_url}/text.js"></script>
<script src="//${sharejs_url}/share.js"></script>
<script src=${"/static/public/js/wiki-edit-page.js" | webpack_asset}></script>
</%def>