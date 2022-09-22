using System;
using System.Collections.Generic;
using TNRD;
using UnityEngine;
using UnityEngine.Localization;
using Utils.Serializables;

namespace NarrativeEvents.Data
{
    [CreateAssetMenu(fileName = "Event", menuName = "Events/Event", order = 0)]
    public class Event : ScriptableObject
    {
        [SerializeField] private LocalizedString _description;
        [SerializeField] private List<ConditionChoiceConsequenceTuple> _choices;

        public LocalizedString Description => _description;

        public List<ConditionChoiceConsequenceTuple> GetAvailableChoices()
        {
            return _choices.FindAll(choice => choice.Requirement == null || choice.Requirement.IsMet());
        }

        public static Event Create(LocalizedString description, List<ConditionChoiceConsequenceTuple> choices)
        {
            var e = ScriptableObject.CreateInstance<Event>();
            e._description = description;
            e._choices = choices;
            return e;
        }
    }

    [Serializable]
    public class ConditionChoiceConsequenceTuple
    {
        [SerializeField] private SerializableInterface<ISerializablePredicate> _requirement;
        [SerializeField] private Choice _choice;
        [SerializeField] private List<Consequence> _consequences;

        public ISerializablePredicate Requirement => _requirement.Value;

        public Choice Choice => _choice;

        public List<Consequence> Consequences => _consequences;

        public ConditionChoiceConsequenceTuple(Choice choice, List<Consequence> consequences)
        {
            _choice = choice;
            _consequences = consequences;
        }
    }
}