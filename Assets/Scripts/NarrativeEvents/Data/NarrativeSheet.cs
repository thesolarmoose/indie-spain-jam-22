using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using UnityEditor;
using UnityEngine;
using Random = UnityEngine.Random;
using SRandom = System.Random;

namespace NarrativeEvents.Data
{
    [CreateAssetMenu(fileName = "NarrativeSheet", menuName = "Events/NarrativeSheet", order = 0)]
    public class NarrativeSheet : ScriptableObject
    {
        [SerializeField] private List<Evento> _events;


#if UNITY_EDITOR
        [ContextMenu("Generate events")]
        private void GenerateEvents()
        {
            EnsureIds();
            
            foreach (var @event in _events)
            {
                // obtener id (posición en lista)
                var id = @event.Id;
                
                // obtener dirección de carpeta
                var folderPath = $"Assets/Data/Events/{id}";
                var existsFolder = Directory.Exists(folderPath);
                if (!existsFolder)
                {
                    Directory.CreateDirectory(folderPath);
                }

                var eventPath = $"{folderPath}/{id}.asset";
                var existsEvent = File.Exists(eventPath);
                if (!existsEvent)
                {
                
                    var serializedEvent = ScriptableObject.CreateInstance<Event>();
                    foreach (var decision in @event.Decisions)
                    {
                        var consequences = decision.Consequences;
                        foreach (var consequence in consequences)
                        {
                            
                        }
                    }

                }
                // ver si existe entrada en localization string table
                // si:
            }
        }

        private void EnsureIds()
        {
            var ids = _events.ConvertAll(e => e.Id);
            for (int i = 0; i < _events.Count; i++)
            {
                var @event = _events[i];
                bool hasId = !string.IsNullOrEmpty(@event.Id);
                if (!hasId)
                {
                    var newId = $"e{i}_{RandomString(6)}";
                    while (ids.Contains(newId))
                    {
                        newId = $"e{i}_{RandomString(6)}";
                    }

                    @event.Id = newId;
                    ids = _events.ConvertAll(e => e.Id);
                }
            }
            EditorUtility.SetDirty(this);
        }

        [ContextMenu("Clear ids")]
        private void ClearIds()
        {
            foreach (var @event in _events)
            {
                @event.Id = "";
            }
            EditorUtility.SetDirty(this);
        }

        [ContextMenu("Print ids")]
        private void PrintIds()
        {
            var ids = _events.ConvertAll(e => e.Id);
            var existDuplicated = ids.Count != ids.Distinct().Count();
            Debug.Log($"duplicated: {existDuplicated}");
            Debug.Log(string.Join("\n", ids));
        }
        
        
        private string RandomString(int length)
        {
            const string chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
            var random = Enumerable.Repeat(chars, length).Select(s => s[Random.Range(0, s.Length)]).ToArray();
            return new string(random);
        }
#endif
        
    }

    [Serializable]
    public class Evento
    {
        [SerializeField, TextArea] private string _description;
        [SerializeField] private List<Decision> _decisions;
        [SerializeField, HideInInspector] private string _id;

        public string Id
        {
            get => _id;
            set => _id = value;
        }

        public string Description => _description;

        public List<Decision> Decisions => _decisions;
    }
    
    [Serializable]
    public class Decision
    {
        [SerializeField, TextArea] private string _description;

        [SerializeField, TextArea] private List<string> _consequences;

        public string Description => _description;

        public List<string> Consequences => _consequences;
    }
}