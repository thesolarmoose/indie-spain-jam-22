using System;
using NarrativeEvents.Data;
using UnityEditor;
using UnityEditor.Localization;
using UnityEngine;
using UnityEngine.Localization.Tables;

namespace Editor
{
    [CustomEditor(typeof(Consequence))]
    public class ConsequencePropertyDrawer : UnityEditor.Editor
    {
        private SerializedProperty _descriptionProperty;
        
        private void OnEnable()
        {
            _descriptionProperty = serializedObject.FindProperty("_description");
        }

        public override void OnInspectorGUI()
        {
            DrawDefaultInspector();
            var consequence = (Consequence) target;
            var description = consequence.Description;
            var table = LocalizationEditorSettings
                .GetStringTableCollection("Consequences")
                .GetTable("es") as StringTable;

            var value = table.GetEntry(description.TableEntryReference.Key).Value;

            var style = new GUIStyle(EditorStyles.textArea)
            {
                wordWrap = true
            };
            EditorGUILayout.LabelField(value, style);
        }
    }
}