invoke-webrequest https://github.com/microsoft/cascadia-code/releases/download/v2404.23/CascadiaCode-2404.23.zip -outfile .zip
expand-archive .zip
copy-item ttf/CascadiaCodeNF.ttf thirdparty/fonts/JetBrainsMono_Regular.ttf
copy-item ttf/static/CascadiaCode-Bold.ttf thirdparty/fonts/NotoSans_Bold.ttf
copy-item ttf/CascadiaCode.ttf thirdparty/fonts/NotoSans_Regular.ttf
remove-item thirdparty/fonts/JetBrainsMono_Regular.woff2, thirdparty/fonts/NotoSans_Bold.woff2, thirdparty/fonts/NotoSans_Regular.woff2
foreach ($file in
  ('scene/2d/physics/entity_2d.h', '#ifndef ENTITY_2D_H
#define ENTITY_2D_H

#include "scene/2d/node_2d.h"

class Entity2D : public Node2D {
	GDCLASS(Entity2D, Node2D);

private:
  String entity_name;

protected:
	static void _bind_methods();

public:
	void set_entity_name(const String &p_string);
	String get_entity_name() const;

	Entity2D();
	~Entity2D();
};

#endif // Entity_2D_H'),
('scene/2d/physics/entity_2d.cpp', '#include "entity_2d.h"

void Entity2D::set_entity_name(const String &p_string) {
	entity_name = p_string;
}

String Entity2D::get_entity_name() const {
	return entity_name;
}

void Entity2D::_bind_methods() {
	ClassDB::bind_method(D_METHOD("set_entity_name", "entity"), &Entity2D::set_entity_name);
	ClassDB::bind_method(D_METHOD("get_entity_name"), &Entity2D::get_entity_name);

	ADD_GROUP("Entity", "entity_");
	ADD_PROPERTY(PropertyInfo(Variant::STRING, "entity_name", PROPERTY_HINT_MULTILINE_TEXT), "set_entity_name", "get_entity_name");
}

Entity2D::Entity2D() {}

Entity2D::~Entity2D() {}')
) { out-file ./$($file[0]) -noclobber -inputobject ($file[1] -replace [Environment]::NewLine, "`n") }

foreach (
  $file in @{
    'scene/2d/physics/collision_object_2d.h' = ('node', 'physics/entity'), ('Node', 'Entity')
    'scene/register_scene_types.cpp' = , ('CollisionObject', 'Entity2D);
	GDREGISTER_ABSTRACT_CLASS(CollisionObject')
    'modules/gdscript/gdscript_tokenizer.cpp' =
      ('P, KEYWORD)     \', 'P, KEYWORD) \
	KEYWORD_GROUP(U''関'')     \
	KEYWORD(U"関数", Token::FUNC)     \'),
      ('!only_ascii', 'false'),
      ('sizeof(keyword)', 'sizeof(keyword) / sizeof(keyword[0])')
    'modules/gdscript/gdscript.cpp' =
      (' *_reserved_words[] = {
		// Control flow.
		"break",
		"continue",
		"elif",
		"else",
		"for",
		"if",
		"match",
		"pass",
		"return",
		"when",
		"while",
		// Declarations.
		"class",
		"class_name",
		"const",
		"enum",
		"extends",
		"func",
		"namespace", // Reserved for potential future use.
		"signal",
		"static",
		"trait", // Reserved for potential future use.
		"var",
		// Other keywords.
		"await",
		"breakpoint",
		"self",
		"super",
		"yield", // Reserved for potential future use.
		// Operators.
		"and",
		"as",
		"in",
		"is",
		"not",
		"or",
		// Special values (tokenizer treats them as literals, not as tokens).
		"false",
		"null",
		"true",
		// Constants.
		"INF",
		"NAN",
		"PI",
		"TAU",
		// Functions (highlighter uses global function color instead).
		"assert",
		"preload",
		// Types (highlighter uses type color instead).
		"', ('32_t *_reserved_words[] = {
		"関数",
		// Control flow.
		"break",
		"continue",
		"elif",
		"else",
		"for",
		"if",
		"match",
		"pass",
		"return",
		"when",
		"while",
		// Declarations.
		"class",
		"class_name",
		"const",
		"enum",
		"extends",
		"func",
		"namespace", // Reserved for potential future use.
		"signal",
		"static",
		"trait", // Reserved for potential future use.
		"var",
		// Other keywords.
		"await",
		"breakpoint",
		"self",
		"super",
		"yield", // Reserved for potential future use.
		// Operators.
		"and",
		"as",
		"in",
		"is",
		"not",
		"or",
		// Special values (tokenizer treats them as literals, not as tokens).
		"false",
		"null",
		"true",
		// Constants.
		"INF",
		"NAN",
		"PI",
		"TAU",
		// Functions (highlighter uses global function color instead).
		"assert",
		"preload",
		// Types (highlighter uses type color instead).
		"' -replace '	"', '	U"')),
      (' **w ', '32_t **w ')
    'editor/editor_settings.cpp' =
      ('/preset", "Default', '/preset", "Black (OLED)'),
      ('nt/type", 0', 'nt/type", 1'),
      ('e", 4', 'e", 2'),
      ('se_delay", 1.5', 'se_delay", 0.1'),
      ('y", 0.3', 'y", 0.01')
  }.getenumerator()
) {
  $content = get-content $file.key -raw
  for ($i = 0; $i -lt $file.value.length; $i++) {
    $content = $content -creplace [Regex]::Escape(($file.value[$i][0] -replace [Environment]::NewLine, "`n")), ($file.value[$i][1] -replace [Environment]::NewLine, "`n")
  }
  set-content $file.key $content
  get-content $file.key -raw
}
invoke-expression (invoke-restmethod -uri https://get.scoop.sh)
scoop install gcc python scons make mingw
scons use_mingw=yes production=yes lto=full optimize=speed_trace steamapi=yes deprecated=no target_win_version=0x0a00 windows_subsystem=console precision=double use_precise_math_checks=yes use_static_cpp=no use_asan=yes warnings=extra module_text_server_adv_enabled=no module_text_server_fb_enabled=yes module_camera_enabled=no module_mobile_vr_enabled=no module_openxr_enabled=no module_webxr_enabled=no
