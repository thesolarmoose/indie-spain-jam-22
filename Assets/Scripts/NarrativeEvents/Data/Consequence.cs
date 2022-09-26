using System.Collections.Generic;
using NaughtyAttributes;
using TNRD;
using UnityEngine;
using UnityEngine.Localization;
using UnityEngine.Localization.Tables;

namespace NarrativeEvents.Data
{
    [CreateAssetMenu(fileName = "Consequence", menuName = "Events/Consequence", order = 0)]
    public class Consequence : ScriptableObject
    {
        [SerializeField] private LocalizedString _description;
        [SerializeField] private Sprite _image;
        [SerializeField] private List<SerializableInterface<IConsequence>> _consequences;

        public LocalizedString Description => _description;

        public Sprite Image => _image;

        private List<IConsequence> Consequences => _consequences.ConvertAll(consequence => consequence.Value);

        public void ExecuteConsequences()
        {
            Consequences.ForEach(consequence => consequence.Execute());
        }

        public static Consequence Empty()
        {
            var consequence = CreateInstance<Consequence>();
            consequence._consequences = new List<SerializableInterface<IConsequence>>();
            return consequence;
        }
    }
}