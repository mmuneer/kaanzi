var scope;
function wiki_init(){
  set_scope();
  init_lightbox();
  set_unwanted();
  hide_all_sections_content();
  setup_sections();
}

function set_scope(){
  scope = $('#wikiInfo').first();
}

function init_lightbox(){
  scope.find('a.lightboxwiki').lightBox({fixedNavigation:true});
}

function set_unwanted(){
  scope.find('.dablink').addClass('unwanted');
  scope.find('.thumb').addClass('unwanted');
  scope.find('.editsection').addClass('unwanted');
  scope.find('.toc').addClass('unwanted');
  scope.find('.vertical-navbox').addClass('unwanted');
}

function hide_all_sections_content(){
  scope.find('.mw-headline:first').parent().nextAll(':not(h2:has(.mw-headline))').hide();
}

function setup_sections(){
  scope.find('h2 > .mw-headline').parent().each(function(index) {
	$(this).click(function(e) {
	  $(this).nextUntil('h2:has(.mw-headline)').not('.unwanted').toggle();
	  $(this).find('#show').toggleClass('show');
	  $(this).find('#hide').toggleClass('hide');
    });
	$(this).css('cursor', 'pointer');
	//$(this).css({'cursor' : 'pointer', 'background-color' : '#FFFFFF'});
	$(this).append("<a id='show' class='show' >&nbsp;</a>");
	$(this).append("<a id='hide' class='' >&nbsp;</a>");
	$(this).append('<hr/>');
  });
}
