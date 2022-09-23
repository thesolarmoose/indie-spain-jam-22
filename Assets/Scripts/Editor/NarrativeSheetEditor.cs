using System.Collections.Generic;
using System.IO;
using System.Linq;
using NarrativeEvents.Data;
using UnityEditor;
using UnityEditor.Localization;
using UnityEngine;
using UnityEngine.Localization.Tables;
using Event = NarrativeEvents.Data.Event;

namespace Editor
{
    public static class NarrativeSheetEditor
    {
        private static readonly string EventsTableName = "NarrativeEvents";
        private static readonly string ChoicesTableName = "Choices";
        private static readonly string ConsequencesTableName = "Consequences";
        
        private static NarrativeSheet GetSheet()
        {
            return AssetDatabase.LoadAssetAtPath<NarrativeSheet>("Assets/Data/Events/_NarrativeSheet.asset");
        }
        
        [MenuItem("Narrative/Generate events from sheet")]
        private static void GenerateEvents()
        {
            var sheet = GetSheet();
            EnsureIds(sheet);
            
            var events = sheet.Events;
            foreach (var @event in events)
            {
                // obtener id (posición en lista)
                var eventId = @event.Id;

                var eventAsset = CreateOrGetAssetAtFolder<Event>(eventId, eventId);
                CreateOrUpdateLocalizationReference(EventsTableName, eventId, @event.Description);
                eventAsset.Description.SetReference(EventsTableName, eventId);

                for (int i = 0; i < @event.Decisions.Count; i++)
                {
                    var decision = @event.Decisions[i];
                    var choiceId = $"{eventId}-ch{i}";
                    var choiceAsset = CreateOrGetAssetAtFolder<Choice>(eventId, choiceId);

                    eventAsset.Choices.Exists(cc => cc.Choice == choiceAsset);
                    
                    CreateOrUpdateLocalizationReference(ChoicesTableName, choiceId, decision.Description);
                    choiceAsset.Description.SetReference(ChoicesTableName, choiceId);
                    EditorUtility.SetDirty(eventAsset);

                    var consequences = decision.Consequences;
                    var consequencesAssets = new List<Consequence>();
                    for (int j = 0; j < consequences.Count; j++)
                    {
                        var consequence = consequences[j];
                        var consequenceId = $"{choiceId}-c{j}";
                        var consequenceAsset = CreateOrGetAssetAtFolder<Consequence>(eventId, consequenceId);
                        CreateOrUpdateLocalizationReference(ConsequencesTableName, consequenceId, consequence);
                        consequenceAsset.Description.SetReference(ConsequencesTableName, consequenceId);
                        EditorUtility.SetDirty(consequenceAsset);
                        consequencesAssets.Add(consequenceAsset);
                    }
                    
                    UpdateChoiceConsequencesInEventAsset(eventAsset, choiceAsset, consequencesAssets);
                }
                
                EditorUtility.SetDirty(eventAsset);
            }
        }
        
        private static void CreateOrUpdateLocalizationReference(string tableName, string entryId, string value)
        {
            var table = LocalizationEditorSettings
                .GetStringTableCollection(tableName)
                .GetTable("es") as StringTable;
            
            table.AddEntry(entryId, value);
            EditorUtility.SetDirty(table);
        }

        private static T CreateOrGetAssetAtFolder<T>(string folder, string assetName) where T : ScriptableObject
        {
            folder = $"Assets/Data/Events/{folder}";
            assetName = $"{assetName}.asset";
            var existsFolder = Directory.Exists(folder);
            if (!existsFolder)
            {
                Directory.CreateDirectory(folder);
            }

            var assetPath = Path.Join(folder, assetName);
            var existsAsset = File.Exists(assetPath);
            T asset;
            if (existsAsset)
            {
                asset = AssetDatabase.LoadAssetAtPath<T>(assetPath);
            }
            else
            {
                asset = ScriptableObject.CreateInstance<T>();
                AssetDatabase.CreateAsset(asset, assetPath);
            }

            return asset;
        }

        private static void UpdateChoiceConsequencesInEventAsset(Event @event, Choice choice, List<Consequence> consequences)
        {
            var tuple = @event.Choices.Find(cc => cc.Choice == choice);
            if (tuple == null)
            {
                tuple = new ConditionChoiceConsequencesTuple(choice, consequences);
                @event.Choices.Add(tuple);
            }
            else
            {
                foreach (var consequence in consequences)
                {
                    if (!tuple.Consequences.Contains(consequence))
                    {
                        tuple.Consequences.Add(consequence);
                    }
                }
            }
        }
        
        private static void EnsureIds(NarrativeSheet sheet)
        {
            var events = sheet.Events;
            var ids = events.ConvertAll(e => e.Id);
            for (int i = 0; i < events.Count; i++)
            {
                var @event = events[i];
                bool hasId = !string.IsNullOrEmpty(@event.Id);
                if (!hasId)
                {
                    var newId = $"e{i}";
                    while (ids.Contains(newId))
                    {
                        newId = $"e{i}_{RandomString(6)}";
                    }

                    @event.Id = newId;
                    ids = events.ConvertAll(e => e.Id);
                }
            }
            EditorUtility.SetDirty(sheet);
        }
        
        private static string RandomString(int length)
        {
            const string chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
            var random = Enumerable.Repeat(chars, length).Select(s => s[Random.Range(0, s.Length)]).ToArray();
            return new string(random);
        }
    }
}